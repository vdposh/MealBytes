//
//  MainViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/03/2025.
//

import SwiftUI
import Combine
import FirebaseCore

protocol MainViewModelProtocol {
    var date: Date { get set }
    var intakeSource: String { get }
    var displayIntake: Bool { get }
    
    func loadMainData() async
    func saveCurrentIntakeMainView(source: String) async
    func saveDisplayIntakeMainView(_ newValue: Bool) async
    func filteredMealItems(for mealType: MealType, on date: Date) -> [MealItem]
    func addMealItemMainView(_ item: MealItem, to: MealType, for: Date)
    func updateMealItemMainView(_ item: MealItem, for: MealType, on: Date)
    func deleteMealItemMainView(with id: UUID, for: MealType)
    func updateIntake(to value: String)
    func collapseSection(for mealType: MealType, to isExpanded: Bool)
    func setDisplayIntake(_ value: Bool)
    func collapseAllSections()
    func resetDateToToday()
}

final class MainViewModel: ObservableObject {
    @Published var date = Date() {
        didSet {
            handleDateChange(from: oldValue, to: date)
        }
    }
    @Published var mealItems: [MealType: [MealItem]]
    @Published var nutrientSummaries: [NutrientType: Double]
    @Published var expandedSections: [MealType: Bool] = [:]
    @Published var appError: AppError?
    @Published var uniqueId = UUID()
    @Published var intakeProgress: Double = 0.0
    @Published var intake: String = ""
    @Published var intakeSource: String = ""
    @Published var isExpandedCalendar: Bool = false
    @Published var isExpanded: Bool = false
    @Published var displayIntake: Bool = true
    
    let formatter = Formatter()
    let calendar = Calendar.current
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    lazy var searchViewModel: SearchViewModelProtocol = SearchViewModel(
        mainViewModel: self
    )
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        var items = [MealType: [MealItem]]()
        MealType.allCases.forEach { items[$0] = [] }
        self.mealItems = items
        var summaries = [NutrientType: Double]()
        NutrientType.allCases.forEach { summaries[$0] = 0.0 }
        self.nutrientSummaries = summaries
        var sections = [MealType: Bool]()
        MealType.allCases.forEach { sections[$0] = false }
        self.expandedSections = sections
        setupBindingsMainView()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Load Main Data
    func loadMainData() async {
        async let mealItemsTask: () = loadMealItemsMainView()
        async let currentIntakeTask: () = loadCurrentIntakeMainView()
        async let displayIntakeTask: () = loadDisplayIntakeMainView()
        
        _ = await (mealItemsTask, currentIntakeTask, displayIntakeTask)
        
        await MainActor.run {
            updateProgress()
        }
    }
    
    // MARK: - Load Meal Item
    private func loadMealItemsMainView() async {
        do {
            let mealItems = try await firestore.loadMealItemsFirestore()
            await MainActor.run {
                self.mealItems = Dictionary(
                    grouping: mealItems,
                    by: { $0.mealType }
                )
                self.recalculateNutrients(for: self.date)
            }
        } catch {
            await MainActor.run {
                self.appError = .network
            }
        }
    }
    
    // MARK: - Add Meal Item
    func addMealItemMainView(
        _ item: MealItem,
        to mealType: MealType,
        for date: Date
    ) {
        mealItems[mealType, default: []].append(item)
        expandedSections[mealType] = true
        recalculateNutrients(for: date)
    }
    
    // MARK: - Update Meal Item
    func updateMealItemMainView(
        _ updatedItem: MealItem,
        for mealType: MealType,
        on date: Date
    ) {
        guard let items = mealItems[mealType] else { return }
        
        if let index = items.firstIndex(where: {
            $0.id == updatedItem.id &&
            calendar.isDate($0.date, inSameDayAs: date)
        }) {
            mealItems[mealType]?[index] = updatedItem
        } else {
            return
        }
        
        Task {
            do {
                try await firestore.updateMealItemFirestore(updatedItem)
                await MainActor.run {
                    recalculateNutrients(for: date)
                }
            } catch {
                await MainActor.run {
                    self.appError = .network
                }
            }
        }
    }
    
    // MARK: - Delete Meal Item
    func deleteMealItemMainView(with id: UUID, for mealType: MealType) {
        var items = mealItems[mealType] ?? []
        if let itemToDelete = items.first(where: { $0.id == id }) {
            items.removeAll { $0.id == id }
            
            let updatedItems = items
            
            Task {
                await MainActor.run {
                    mealItems[mealType] = updatedItems
                    recalculateNutrients(for: date)
                }
                
                do {
                    try await firestore
                        .deleteMealItemFirestore(itemToDelete)
                } catch {
                    await MainActor.run {
                        self.appError = .network
                    }
                }
            }
        }
    }
    
    func deletionButtonRole(for mealType: MealType) -> ButtonRole? {
        return filteredMealItems(
            for: mealType,
            on: date
        ).count == 1 ? nil : .destructive
    }
    
    // MARK: - Load Current Intake
    private func loadCurrentIntakeMainView() async {
        do {
            let fetchedData = try await firestore.loadCurrentIntakeFirestore()
            await MainActor.run {
                self.intake = fetchedData.intake
                self.intakeSource = fetchedData.source
            }
        } catch {
            await MainActor.run {
                self.appError = .network
            }
        }
    }
    
    // MARK: - Save Current Intake
    func saveCurrentIntakeMainView(source: String) async {
        do {
            let intakeData = CurrentIntake(intake: intake, source: source)
            try await firestore.saveCurrentIntakeFirestore(intakeData)
            
            await MainActor.run {
                self.intakeSource = source
            }
        } catch {
            await MainActor.run {
                appError = .network
            }
        }
    }
    
    // MARK: - Load Display Intake
    private func loadDisplayIntakeMainView() async {
        do {
            let value = try await firestore.loadDisplayIntakeFirestore()
            await MainActor.run {
                displayIntake = value
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Save Display Intake
    func saveDisplayIntakeMainView(_ newValue: Bool) async {
        await MainActor.run {
            displayIntake = newValue
        }
        
        do {
            try await firestore.saveDisplayIntakeFirestore(newValue)
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    //MARK: - Calculation (Intake)
    private func setupBindingsMainView() {
        $mealItems
            .combineLatest($nutrientSummaries)
            .sink { [weak self] _, _ in
                guard let self else { return }
                self.updateProgress()
            }
            .store(in: &cancellables)
    }
    
    private func calculateIntakePercentage(from calories: Double?) -> String {
        guard let intakeValue = Double(intake),
              intakeValue > 0 else { return "0%" }
        let safeCalories = calories ?? 0.0
        let percentage = round((safeCalories / intakeValue) * 100)
        return "\(Int(percentage))%"
    }
    
    private func updateIntakeProgress(calories: Double) {
        guard let intakeValue = Double(intake), intakeValue > 0 else {
            intakeProgress = 0.0
            return
        }
        intakeProgress = min(max(calories / intakeValue, 0), 1)
    }
    
    private func updateProgress() {
        let calories = summariesForCaloriesSection()[.calories] ?? 0.0
        updateIntakeProgress(calories: calories)
    }
    
    func intakePercentageText(for calories: Double?) -> String {
        return calculateIntakePercentage(from: calories ?? 0.0)
    }
    
    func canDisplayIntake() -> Bool {
        return displayIntake && !intake.isEmpty
    }
    
    // MARK: - Recalculate Nutrients
    private func recalculateNutrients(for date: Date) {
        nutrientSummaries = mealItems.values.reduce(
            into: [NutrientType: Double]()
        ) { result, mealList in
            mealList.forEach { item in
                guard calendar.isDate(
                    item.date,
                    inSameDayAs: date
                ) else { return }
                item.nutrients.forEach { nutrient, value in
                    result[nutrient, default: 0.0] += value
                }
            }
        }
    }
    
    // MARK: - Summary Calories
    func summariesForCaloriesSection() -> [NutrientType: Double] {
        mealItems.values.reduce(
            into: [NutrientType: Double]()) { result, items in
                items.forEach { item in
                    guard calendar.isDate(
                        item.date,
                        inSameDayAs: date
                    ) else { return }
                    item.nutrients.forEach { nutrient, value in
                        result[nutrient, default: 0.0] += value
                    }
                }
            }
    }
    
    // MARK: - Filter Meal Items
    func filteredMealItems(
        for mealType: MealType,
        on date: Date
    ) -> [MealItem] {
        return mealItems[mealType, default: []].filter {
            calendar.isDate($0.date, inSameDayAs: date)
        }
    }
    
    // MARK: - Filtered Nutrients
    var filteredNutrients: [DetailedNutrient] {
        let allNutrients = DetailedNutrientProvider()
            .getDetailedNutrients(from: nutrientSummaries)
        
        switch isExpanded {
        case true: return allNutrients
        case false:
            return allNutrients.filter {
                [.calories, .fat, .protein, .carbohydrate].contains($0.type)
            }
        }
    }
    
    // MARK: - Format Serving Size
    private func formattedServingSize(for mealItem: MealItem) -> String {
        return formatter.formattedValue(
            mealItem.nutrients[.servingSize],
            unit: .empty
        )
    }
    
    private func formattedMeasurement(for mealItem: MealItem) -> String {
        if mealItem.measurementDescription.starts(with: "serving (") {
            return "serving"
        } else {
            return mealItem.measurementDescription
        }
    }
    
    func formattedMealText(for mealItem: MealItem) -> String {
        let formattedAmount = formatter.formattedValue(
            mealItem.amount,
            unit: .empty
        )
        
        let measurement = formattedMeasurement(for: mealItem)
            .pluralized(for: mealItem.amount)
        
        if measurement == "g" || measurement == "ml" {
            return "\(formattedServingSize(for: mealItem))\(mealItem.portionUnit)"
        }
        
        return "\(formattedAmount) \(measurement) (\(formattedServingSize(for: mealItem))\(mealItem.portionUnit))"
    }
    
    // MARK: - Format Calories
    func formattedCalories(_ calories: Double) -> String {
        return formatter.formattedValue(
            calories,
            unit: .empty,
            alwaysRoundUp: true
        )
    }
    
    // MARK: - Format Value
    func formattedValue(
        _ value: Double,
        unit: Formatter.Unit,
        alwaysRoundUp: Bool
    ) -> String {
        return formatter.formattedValue(
            value,
            unit: unit,
            alwaysRoundUp: alwaysRoundUp
        )
    }
    
    // MARK: - Calculate Totals for Nutrients
    func totalNutrient(
        _ nutrient: NutrientType,
        for mealItems: [MealItem]
    ) -> Double {
        mealItems.reduce(0) { $0 + ($1.nutrients[nutrient] ?? 0.0) }
    }
    
    // MARK: - Formatting nutrients
    func formattedNutrients(
        source: NutrientSource
    ) -> [String: String] {
        func format(_ value: Double?) -> String {
            formatter.formattedValue(value, unit: .empty)
        }
        
        switch source {
        case .summaries(let summaries):
            return [
                "Fat": format(summaries[.fat]),
                "Carbs": format(summaries[.carbohydrate]),
                "Protein": format(summaries[.protein])
            ]
        case .details(let fat, let carbohydrate, let protein):
            return [
                "F": format(fat),
                "C": format(carbohydrate),
                "P": format(protein)
            ]
        }
    }
    
    // MARK: - Calculate Date Offset
    func dateByAddingOffset(for offset: Int) -> Date {
        Calendar.current.date(
            byAdding: .day,
            value: offset,
            to: Date()
        ) ?? Date()
    }
    
    
    func dayComponent(for date: Date) -> Int {
        calendar.component(.day, from: date)
    }
    
    // MARK: - Formatted year for Calendar
    func formattedDate() -> String {
        if calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
            return date.formatted(
                .dateTime.weekday(.wide).day().month(.wide)
            )
        } else {
            return date.formatted(
                .dateTime.weekday(.wide).day().month(.wide).year()
            )
        }
    }
    
    // MARK: - Color for Calendar
    func color(
        for element: DisplayElement,
        date: Date? = nil,
        isSelected: Bool = false,
        isToday: Bool = false,
        forBackground: Bool = false,
        forcePrimary: Bool = false
    ) -> Color {
        if forBackground {
            return isSelected ? .customGreen.opacity(0.2) : .clear
        }
        if isSelected || isToday {
            return .customGreen
        }
        if forcePrimary {
            return .primary
        }
        if let date, !calendar.isDate(
            date,
            equalTo: self.date,
            toGranularity: .month
        ) {
            return .secondary
        }
        return element == .day ? .primary : .secondary
    }
    
    // MARK: - Date (calendar) Management Methods
    func hasMealItems(for date: Date) -> Bool {
        return mealItems.values.first { items in
            items.first { calendar.isDate($0.date, inSameDayAs: date) } != nil
        } != nil
    }
    
    func selectDate(
        _ date: Date,
        selectedDate: inout Date,
        isPresented: inout Bool
    ) {
        selectedDate = date
        isPresented = false
    }
    
    func changeMonth(by value: Int, selectedDate: inout Date) {
        if let newDate = calendar.date(
            byAdding: .month,
            value: value,
            to: selectedDate
        ) {
            selectedDate = newDate
        }
    }
    
    func daysForCurrentMonth(selectedDate: Date) -> [Date] {
        guard let startOfMonth = calendar.date(
            from: DateComponents(
                year: calendar.component(.year, from: selectedDate),
                month: calendar.component(.month, from: selectedDate),
                day: 1
            )
        ),
              let range = calendar.range(
                of: .day,
                in: .month,
                for: startOfMonth
              ),
              let prevMonth = calendar.date(
                byAdding: .month,
                value: -1,
                to: startOfMonth
              ),
              let prevMonthRange = calendar.range(
                of: .day,
                in: .month,
                for: prevMonth
              )
        else { return [] }
        
        let days = range.compactMap {
            calendar.date(byAdding: .day, value: $0 - 1, to: startOfMonth)
        }
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth) - 1
        let adjustedWeekday = firstWeekday == 0 ? 6 : (firstWeekday - 1)
        
        let prevDays = prevMonthRange.compactMap {
            calendar.date(byAdding: .day, value: $0 - 1, to: prevMonth)
        }
            .suffix(adjustedWeekday)
        
        let fillerCount = (7 - (days.count + adjustedWeekday) % 7) % 7
        
        let nextDays: [Date] = (
            fillerCount > 0
            ? Array(1...fillerCount)
            : []
        ).compactMap {
            guard let last = days.last else { return nil }
            let candidate = calendar.date(byAdding: .day, value: $0, to: last)
            
            guard let date = candidate else { return nil }
            
            return calendar.isDate(
                date,
                equalTo: startOfMonth,
                toGranularity: .month
            )
            ? nil : date
        }
        
        return Array(prevDays) + days + nextDays
    }
    
    private func handleDateChange(from oldDate: Date, to newDate: Date) {
        guard !calendar.isDate(oldDate, inSameDayAs: newDate) else { return }
        
        recalculateNutrients(for: newDate)
        updateProgress()
        collapseAllSections()
    }
    
    //MARK: - Close sections
    func collapseAllSections() {
        expandedSections.keys.forEach { key in
            expandedSections[key] = false
        }
    }
}

enum NutrientSource {
    case summaries([NutrientType: Double])
    case details(fat: Double, carbohydrate: Double, protein: Double)
}

enum DisplayElement {
    case day
    case weekday
}

extension MainViewModel: MainViewModelProtocol {
    func resetDateToToday() {
        date = Date()
    }
    
    func collapseSection(for mealType: MealType, to isExpanded: Bool) {
        expandedSections[mealType] = isExpanded
    }
    
    func setDisplayIntake(_ value: Bool) {
        displayIntake = value
    }
    
    func updateIntake(to value: String) {
        intake = value
    }
}

#Preview {
    PreviewContentView.contentView
}
