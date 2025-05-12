//
//  MainViewModel.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI
import Combine
import FirebaseCore

final class MainViewModel: ObservableObject {
    @Published var date = Date() {
        didSet {
            recalculateNutrients(for: date)
            updateProgress()
            collapseAllSections()
        }
    }
    @Published var mealItems: [MealType: [MealItem]]
    @Published var nutrientSummaries: [NutrientType: Double]
    @Published var expandedSections: [MealType: Bool] = [:]
    @Published var uniqueID = UUID()
    @Published var appError: AppError?
    @Published var rdiProgress: Double = 0.0
    @Published var rdi: String = ""
    @Published var isExpandedCalendar: Bool = false
    @Published var isExpanded: Bool = false
    @Published var shouldDisplayRdi: Bool = true
    
    let calendar = Calendar.current
    let formatter = Formatter()
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    lazy var searchViewModel = SearchViewModel(mainViewModel: self)
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
        setupBindings()
    }
    
    deinit {
        cancellables.removeAll()
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
    
    // MARK: - Add Food Item
    func addMealItemMainView(_ item: MealItem,
                             to mealType: MealType,
                             for date: Date) {
        mealItems[mealType, default: []].append(item)
        expandedSections[mealType] = true
        recalculateNutrients(for: date)
    }
    
    // MARK: - Update Meal Item
    func updateMealItemMainView(_ updatedItem: MealItem,
                                for mealType: MealType,
                                on date: Date) {
        guard var items = mealItems[mealType] else { return }
        
        if let index = items.firstIndex(where: {
            $0.id == updatedItem.id &&
            calendar.isDate($0.date, inSameDayAs: date)
        }) {
            items[index] = updatedItem
        }
        
        let updatedItems = items
        
        Task {
            do {
                try await firestore.updateMealItemFirestore(updatedItem)
                await MainActor.run {
                    mealItems[mealType] = updatedItems
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
                    
                    if filteredMealItems(for: mealType, on: date).isEmpty {
                        expandedSections[mealType] = false
                    }
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
    
    // MARK: - Load RDI
    private func loadMainRdiMainView() async {
        do {
            let fetchedRdi = try await firestore.loadMainRdiFirestore()
            await MainActor.run {
                self.rdi = fetchedRdi
            }
        } catch {
            await MainActor.run {
                self.appError = .network
            }
        }
    }
    
    // MARK: - Save RDI
    func saveMainRdiMainView() async {
        do {
            try await firestore.saveMainRdiFirestore(rdi)
        } catch {
            await MainActor.run {
                appError = .network
            }
        }
    }
    
    // MARK: - Load Display RDI
    private func loadDisplayRdiMainView() async {
        do {
            let value = try await firestore.loadDisplayRdiFirestore()
            await MainActor.run {
                shouldDisplayRdi = value
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Save Display RDI
    func saveDisplayRdiMainView(_ newValue: Bool) async {
        await MainActor.run {
            shouldDisplayRdi = newValue
        }
        do {
            try await firestore.saveDisplayRdiFirestore(newValue)
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Load Data
    func loadMainData() async {
        async let mealItemsTask: () = loadMealItemsMainView()
        async let bookmarksTask: () = searchViewModel.loadBookmarksSearchView()
        async let mainRdiTask: () = loadMainRdiMainView()
        async let displayRdiTask: () = loadDisplayRdiMainView()
        
        _ = await (mealItemsTask, bookmarksTask, mainRdiTask, displayRdiTask)
        
        await MainActor.run {
            updateProgress()
        }
    }
    
    //MARK: - RDI % calculation
    private func calculateRdiPercentage(from calories: Double?) -> String {
        guard let rdiValue = Double(rdi), rdiValue > 0 else { return "RDI 0%" }
        let safeCalories = calories ?? 0.0
        let percentage = round((safeCalories / rdiValue) * 100)
        return "RDI \(Int(percentage))%"
    }
    
    private func updateRdiProgress(calories: Double) {
        guard let rdiValue = Double(rdi), rdiValue > 0 else {
            rdiProgress = 0.0
            return
        }
        rdiProgress = min(max(calories / rdiValue, 0), 1)
    }
    
    private func updateProgress() {
        let calories = summariesForCaloriesSection()[.calories] ?? 0.0
        updateRdiProgress(calories: calories)
    }
    
    func rdiPercentageText(for calories: Double?) -> String {
        return calculateRdiPercentage(from: calories ?? 0.0)
    }
    
    private func setupBindings() {
        $mealItems
            .combineLatest($nutrientSummaries)
            .sink { [weak self] _, _ in
                guard let self else { return }
                self.updateProgress()
            }
            .store(in: &cancellables)
    }
    
    func canDisplayRdi() -> Bool {
        return shouldDisplayRdi && !rdi.isEmpty
    }
    
    // MARK: - Recalculate Nutrients
    private func recalculateNutrients(for date: Date) {
        nutrientSummaries = mealItems.values.reduce(
            into: [NutrientType: Double]()) { result, mealList in
                mealList.forEach { item in
                    guard calendar.isDate(item.date,
                                          inSameDayAs: date) else { return }
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
                    guard calendar.isDate(item.date,
                                          inSameDayAs: date) else { return }
                    item.nutrients.forEach { nutrient, value in
                        result[nutrient, default: 0.0] += value
                    }
                }
            }
    }
    
    // MARK: - Filter Meal Items
    func filteredMealItems(for mealType: MealType,
                           on date: Date) -> [MealItem] {
        return mealItems[mealType, default: []].filter {
            calendar.isDate($0.date, inSameDayAs: date)
        }
    }
    
    // MARK: - Filtered Nutrients
    var filteredNutrients: [DetailedNutrient] {
        let allNutrients = DetailedNutrientProvider()
            .getDetailedNutrients(from: nutrientSummaries)
        
        switch isExpanded {
        case true:
            return allNutrients
        case false:
            return allNutrients.filter {
                [.calories, .fat, .protein, .carbohydrate].contains($0.type)
            }
        }
    }
    
    // MARK: - Value for Nutrient Type
    func value(for type: NutrientType) -> Double {
        nutrientSummaries[type] ?? 0.0
    }
    
    // MARK: - Format Serving Size
    func formattedServingSize(for mealItem: MealItem) -> String {
        return formatter.formattedValue(mealItem.nutrients[.servingSize],
                                        unit: .empty)
    }
    
    func formattedMeasurement(for mealItem: MealItem) -> String {
        if mealItem.measurementDescription.starts(with: "serving (") {
            return "serving"
        } else {
            return mealItem.measurementDescription
        }
    }
    
    func formattedMealText(for mealItem: MealItem) -> String {
        let formattedAmount = formatter.formattedValue(mealItem.amount,
                                                       unit: .empty)
        let measurement = formattedMeasurement(for: mealItem)
        
        if measurement == "g" || measurement == "ml" {
            return "\(formattedServingSize(for: mealItem))\(mealItem.portionUnit)"
        }
        
        return "\(formattedAmount) \(measurement) (\(formattedServingSize(for: mealItem))\(mealItem.portionUnit))"
    }
    
    // MARK: - Format Calories
    func formattedCalories(_ calories: Double) -> String {
        return formatter.formattedValue(calories,
                                        unit: .empty,
                                        alwaysRoundUp: true)
    }
    
    // MARK: - Format Value
    func formattedValue(_ value: Double,
                        unit: Formatter.Unit,
                        alwaysRoundUp: Bool) -> String {
        return formatter.formattedValue(value,
                                        unit: unit,
                                        alwaysRoundUp: alwaysRoundUp)
    }
    
    // MARK: - Calculate Totals for Nutrients
    func totalNutrient(_ nutrient: NutrientType,
                       for mealItems: [MealItem]) -> Double {
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
        Calendar.current.date(byAdding: .day,
                              value: offset,
                              to: Date()) ?? Date()
    }
    
    
    func dayComponent(for date: Date) -> Int {
        calendar.component(.day, from: date)
    }
    
    // MARK: - Formatted year for Calendar
    func formattedDate() -> String {
        switch calendar.isDate(date,
                               equalTo: Date(),
                               toGranularity: .year) {
        case true:
            date.formatted(.dateTime.month(.wide).day().weekday(.wide))
        case false:
            date.formatted(.dateTime.month(.wide).day().weekday(.wide).year())
        }
    }
    
    // MARK: - Color for Calendar
    func color(for element: DisplayElement,
               date: Date? = nil,
               isSelected: Bool = false,
               isToday: Bool = false,
               forBackground: Bool = false,
               forcePrimary: Bool = false) -> Color {
        if forBackground {
            return isSelected ? .customGreen.opacity(0.2) : .clear
        }
        if isSelected || isToday {
            return .customGreen
        }
        if forcePrimary {
            return .primary
        }
        if let date, !calendar.isDate(date,
                                      equalTo: self.date,
                                      toGranularity: .month) {
            return .secondary
        }
        return element == .day ? .primary : .secondary
    }
    
    // MARK: - Date (calendar) Management Methods
    func selectDate(_ date: Date,
                    selectedDate: inout Date,
                    isPresented: inout Bool) {
        selectedDate = date
        isPresented = false
    }
    
    func changeMonth(by value: Int, selectedDate: inout Date) {
        if let newDate = calendar.date(byAdding: .month,
                                       value: value,
                                       to: selectedDate) {
            selectedDate = newDate
        }
    }
    
    func daysForCurrentMonth(selectedDate: Date) -> [Date] {
        guard let startOfMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: selectedDate)
        ),
              let range = calendar.range(of: .day,
                                         in: .month,
                                         for: startOfMonth)
        else { return [] }
        
        let daysInMonth = range.compactMap {
            calendar.date(byAdding: .day, value: $0 - 1, to: startOfMonth)
        }
        
        let firstWeekday = max(calendar.component(.weekday,
                                                  from: startOfMonth) - 2, 0)
        let previousMonthDates = (0..<firstWeekday).reversed().compactMap {
            calendar.date(byAdding: .day, value: -$0 - 1, to: startOfMonth)
        }
        
        let remainingDays = max(0, (7 - (daysInMonth.count + firstWeekday) % 7))
        let nextMonthDates: [Date] = remainingDays > 0
        ? (1...remainingDays).compactMap { offset in
            guard let lastDay = daysInMonth.last else { return nil }
            return calendar.date(byAdding: .day, value: offset, to: lastDay)
        }
        : []
        
        return previousMonthDates + daysInMonth + nextMonthDates
    }
    
    //MARK: - Close all sections
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

#Preview {
    NavigationStack {
        MainView(mainViewModel: MainViewModel())
    }
}
