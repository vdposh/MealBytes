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
    var intake: String { get }
    
    func loadMainData() async
    func saveCurrentIntakeMainView(source: String) async
    func saveDisplayIntakeMainView(_ newValue: Bool) async
    func filteredMealItems(for mealType: MealType, on date: Date) -> [MealItem]
    func triggerFoodAlert()
    func addMealItemMainView(_ item: MealItem, to: MealType, for: Date)
    func updateMealItemMainView(_ item: MealItem, for: MealType, on: Date)
    func deleteMealItemMainView(with id: UUID, for: MealType)
    func intakePercentage(for calories: Double) -> String
    func updateIntake(to value: String)
    func setSectionExpanded(for mealType: MealType, to isExpanded: Bool)
    func setDisplayIntake(_ value: Bool)
    func canDisplayIntake() -> Bool
    func formattedDate() -> String
    func resetDateToToday()
    func resetMainState()
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
    @Published var uniqueId: UUID?
    @Published var selectedMealType: MealType?
    @Published var mealTypeToClear: MealType?
    @Published var intakeProgress: Double = 0.0
    @Published var intake: String = ""
    @Published var intakeSource: String = ""
    @Published var isFoodAddedAlertVisible: Bool = false
    @Published var isAlertInProgress: Bool = false
    @Published var showDatePicker: Bool = false
    @Published var showNutrientTotals: Bool = false
    @Published var showClearDayAlert: Bool = false
    @Published var showClearMealTypeAlert: Bool = false
    @Published var isExpanded: Bool = false
    @Published var displayIntake: Bool = true
    
    let calendar = Calendar.current
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    lazy var searchViewModel: SearchViewModelProtocol = SearchViewModel(
        mainViewModel: self
    )
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        var items = [MealType: [MealItem]]()
        var summaries = [NutrientType: Double]()
        var sections = [MealType: Bool]()
        
        MealType.allCases.forEach { items[$0] = [] }
        NutrientType.allCases.forEach { summaries[$0] = 0.0 }
        MealType.allCases.forEach { sections[$0] = true }
        
        self.mealItems = items
        self.nutrientSummaries = summaries
        self.expandedSections = sections
    }
    
    // MARK: - Load Main Data
    func loadMainData() async {
        async let mealItemsTask: () = loadMealItemsMainView()
        async let currentIntakeTask: () = loadCurrentIntakeMainView()
        async let displayIntakeTask: () = loadDisplayIntakeMainView()
        
        _ = await (mealItemsTask, currentIntakeTask, displayIntakeTask)
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
                
                updateProgress()
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
        
        updateProgress()
    }
    
    // MARK: - Update Meal Item
    func updateMealItemMainView(
        _ updatedItem: MealItem,
        for mealType: MealType,
        on date: Date
    ) {
        guard let items = mealItems[mealType] else { return }
        
        if let index = items.firstIndex(
            where: { $0.id == updatedItem.id
                && calendar.isDate($0.date, inSameDayAs: date)
            }
        ) {
            mealItems[mealType]?[index] = updatedItem
        }
        
        updateProgress()
    }
    
    // MARK: - Move Meal Item
    func moveMealItem(_ item: MealItem, to newMealType: MealType) {
        guard item.mealType != newMealType else { return }
        
        let updatedItem = MealItem(
            id: item.id,
            foodId: item.foodId,
            foodName: item.foodName,
            portionUnit: item.portionUnit,
            nutrients: item.nutrients,
            measurementDescription: item.measurementDescription,
            amount: item.amount,
            date: item.date,
            mealType: newMealType,
            createdAt: Date()
        )
        
        withAnimation {
            var newMealItems = mealItems
            newMealItems[item.mealType]?.removeAll { $0.id == item.id }
            newMealItems[newMealType, default: []].append(updatedItem)
            mealItems = newMealItems
            
            expandedSections[newMealType] = true
        }
        
        Task {
            do {
                try await firestore.updateMealItemFirestore(updatedItem)
            } catch {
                await MainActor.run {
                    appError = .network
                }
            }
        }
    }
    
    // MARK: - Delete Meal Item
    func deleteMealItemMainView(with id: UUID, for mealType: MealType) {
        let itemToDelete = mealItems[mealType]?.first(where: { $0.id == id })
        
        withAnimation {
            var newMealItems = mealItems
            newMealItems[mealType]?.removeAll { $0.id == id }
            mealItems = newMealItems
            
            updateProgress()
        }
        
        Task {
            guard let itemToDelete else { return }
            
            do {
                try await firestore.deleteMealItemFirestore(itemToDelete)
            } catch {
                await MainActor.run {
                    appError = .network
                }
            }
        }
    }
    
    // MARK: - Clear Day
    func clearDay() {
        let dateToClear = date
        
        withAnimation {
            for mealType in MealType.allCases {
                mealItems[mealType] = mealItems[mealType]?.filter {
                    !calendar.isDate($0.date, inSameDayAs: dateToClear)
                }
            }
            
            updateProgress()
        }
        
        Task {
            do {
                try await firestore.deleteMealItemsFirestore(on: dateToClear)
            } catch {
                await MainActor.run {
                    appError = .network
                }
            }
        }
    }
    
    // MARK: - Clear Meal Type
    func clearMealType(_ mealType: MealType) {
        let dateToClear = date
        
        let itemsToDelete = filteredMealItems(for: mealType, on: dateToClear)
        
        withAnimation {
            mealItems[mealType] = mealItems[mealType]?.filter {
                !calendar.isDate($0.date, inSameDayAs: dateToClear)
            }
            
            updateProgress()
        }
        
        Task {
            do {
                for item in itemsToDelete {
                    try await firestore.deleteMealItemFirestore(item)
                }
            } catch {
                await MainActor.run {
                    appError = .network
                }
            }
        }
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
                appError = .network
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
                appError = .network
            }
        }
    }
    
    // MARK: - Calculation (Intake)
    func totalIntakePercentage(for mealType: MealType? = nil) -> String {
        let types: [MealType] = mealType.map { [$0] } ?? MealType.allCases
        
        let totalCalories = types.reduce(0.0) { sum, type in
            let items = filteredMealItems(for: type, on: date)
            let calories = items.reduce(0.0) { $0 + $1.caloriesValue }
            return sum + calories
        }
        
        guard let intakeValue = intake.doubleValue, intakeValue > 0 else {
            return "0%"
        }
        
        let percentage = totalCalories / intakeValue
        return percentage.asPercentage()
    }
    
    func intakePercentage(for calories: Double) -> String {
        guard let intakeValue = intake.doubleValue, intakeValue > 0 else {
            return "0%"
        }
        let percentage = (calories / intakeValue)
        return percentage.asPercentage()
    }
    
    func progressValue(for mealType: MealType) -> Double {
        let calories = filteredMealItems(for: mealType, on: date).reduce(0) {
            $0 + ($1.nutrients[.calories] ?? 0)
        }
        guard let intakeValue = intake.doubleValue, intakeValue > 0 else {
            return 0
        }
        return min(max(calories / intakeValue, 0), 1)
    }
    
    private func updateProgress() {
        let calories = summariesForCaloriesSection()[.calories] ?? 0.0
        updateIntakeProgress(calories: calories)
        recalculateNutrients(for: date)
    }
    
    private func updateIntakeProgress(calories: Double) {
        guard let intakeValue = intake.doubleValue, intakeValue > 0 else {
            intakeProgress = 0.0
            return
        }
        
        intakeProgress = calories / intakeValue
    }
    
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
    
    // MARK: - Calculation (Calories)
    func totalCalories(for mealType: MealType? = nil) -> Double {
        let types: [MealType] = mealType.map { [$0] } ?? MealType.allCases
        
        return types.reduce(0) { sum, type in
            let items = filteredMealItems(for: type, on: date)
            let typeTotal = items.reduce(0) {
                $0 + Int($1.nutrients[.calories] ?? 0)
            }
            return sum + Double(typeTotal)
        }
    }
    
    var remainingCalories: Double {
        let total = totalCalories()
        let intake = self.intake.doubleValue ?? 0
        return intake - total
    }
    
    var isOverLimit: Bool {
        remainingCalories < 0
    }
    
    var remainingCaloriesText: String {
        abs(remainingCalories).asWhole()
    }
    
    var remainingCaloriesWord: String {
        isOverLimit ? "over" : "under"
    }
    
    var remainingCaloriesUnit: String {
        let value = abs(remainingCalories)
        return value == 1 ? "calorie" : "calories"
    }
    
    var remainingCaloriesWordColor: Color {
        isOverLimit ? .customRed : .accent
    }
    
    // MARK: - Calculation (Nutrients)
    func totalNutrients(for mealType: MealType? = nil) -> (
        fat: Double,
        carbs: Double,
        protein: Double
    ) {
        let types: [MealType] = mealType.map { [$0] } ?? MealType.allCases
        
        return types.reduce((0, 0, 0)) { result, type in
            let items = filteredMealItems(for: type, on: date)
            let typeTotal = items.reduce((0, 0, 0)) { partialResult, item in
                (
                    partialResult.0 + (item.nutrients[.fat] ?? 0),
                    partialResult.1 + (item.nutrients[.carbohydrate] ?? 0),
                    partialResult.2 + (item.nutrients[.protein] ?? 0)
                )
            }
            return (
                result.0 + typeTotal.0,
                result.1 + typeTotal.1,
                result.2 + typeTotal.2
            )
        }
    }
    
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
    
    func macroDistribution(
        from summary: [NutrientType: Double]
    ) -> [NutrientType: Int] {
        let values: [(NutrientType, Double)] = [
            (.fat, summary[.fat] ?? 0),
            (.carbohydrate, summary[.carbohydrate] ?? 0),
            (.protein, summary[.protein] ?? 0)
        ]
        let total = values.reduce(0) { $0 + $1.1 }
        
        guard total > 0 else { return [:] }
        
        let sorted = values.sorted { $0.1 > $1.1 }
        let first = sorted[0]
        let second = sorted[1]
        let third = sorted[2]
        let firstPercent = Int(round((first.1 / total) * 100))
        let secondPercent = Int(round((second.1 / total) * 100))
        let thirdPercent = max(0, 100 - firstPercent - secondPercent)
        let result: [NutrientType: Int] = [
            first.0: firstPercent,
            second.0: secondPercent,
            third.0: thirdPercent
        ]
        
        return result
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
    
    var hasMealItems: Bool {
        mealItems.values.contains {
            $0.contains {
                calendar.isDate($0.date, inSameDayAs: date)
            }
        }
    }
    
    func hasMealItemsForMealType(
        for mealType: MealType,
        on date: Date
    ) -> Bool {
        let items = mealItems[mealType] ?? []
        
        return items.contains {
            calendar.isDate($0.date, inSameDayAs: date)
        }
    }
    
    // MARK: - Filtered Nutrients
    var filteredNutrientValues: [NutrientValue] {
        NutrientValueProvider().fromSummary(nutrientSummaries)
    }
    
    // MARK: - Format Serving Size
    func formattedMealText(for mealItem: MealItem) -> String {
        let formattedAmount = mealItem.amount.asDecimal()
        let measurement = formattedMeasurement(for: mealItem)
            .pluralized(for: mealItem.amount)
        
        let servingSize = formattedServingSize(for: mealItem)
        
        if servingSize.isEmpty || servingSize == "0" {
            return "\(formattedAmount) \(measurement)"
        }
        
        if measurement == "g" || measurement == "ml" {
            return "\(servingSize) \(mealItem.portionUnit)"
        }
        
        return "\(formattedAmount) \(measurement) (\(servingSize) \(mealItem.portionUnit))"
    }
    
    private func formattedServingSize(for mealItem: MealItem) -> String {
        return (mealItem.nutrients[.servingSize] ?? 0).asDecimal()
    }
    
    private func formattedMeasurement(for mealItem: MealItem) -> String {
        if mealItem.measurementDescription.starts(with: "serving (") {
            return "serving"
        } else {
            return mealItem.measurementDescription
        }
    }
    
    // MARK: - Date
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
    
    private func handleDateChange(from oldDate: Date, to newDate: Date) {
        guard !calendar.isDate(oldDate, inSameDayAs: newDate) else { return }
        
        recalculateNutrients(for: newDate)
        updateProgress()
        expandAllSections()
        isExpanded = false
    }
    
    var isTodaySelected: Bool {
        calendar.isDate(date, inSameDayAs: Date())
    }
    
    // MARK: - Expand and Close sections
    func expandAllSections() {
        expandedSections.keys.forEach { key in
            expandedSections[key] = true
        }
    }
    
    func collapseAllSections() {
        expandedSections.keys.forEach { key in
            expandedSections[key] = false
        }
    }
    
    // MARK: - Reset State
    func resetMainState() {
        selectedMealType = nil
        
        updateIntake(to: "")
        expandAllSections()
        resetDateToToday()
        setDisplayIntake(true)
    }
    
    // MARK: - Alert
    func formattedDateForAlert() -> String {
        let calendar = calendar
        
        if calendar.isDate(date, inSameDayAs: Date()) {
            return "today"
        }
        
        if let yesterday = calendar.date(
            byAdding: .day,
            value: -1,
            to: Date()
        ),
           calendar.isDate(date, inSameDayAs: yesterday) {
            return "yesterday"
        }
        
        if let tomorrow = calendar.date(
            byAdding: .day,
            value: 1,
            to: Date()
        ),
           calendar.isDate(date, inSameDayAs: tomorrow) {
            return "tomorrow"
        }
        
        return date.formatted(date: .long, time: .omitted)
    }
    
    func triggerFoodAlert() {
        Task { @MainActor in
            guard !isAlertInProgress else {
                try? await Task.sleep(for: .seconds(0.3))
                triggerFoodAlert()
                return
            }
            
            isAlertInProgress = true
            
            isFoodAddedAlertVisible = true
            
            try? await Task.sleep(for: .seconds(1.5))
            isFoodAddedAlertVisible = false
            
            try? await Task.sleep(for: .seconds(0.3))
            isAlertInProgress = false
        }
    }
    
    // MARK: - UI Helper
    func scrollToTop() {
        guard let windowScene = UIApplication
            .shared.connectedScenes.first as? UIWindowScene,
              let rootView = windowScene
            .windows.first?.rootViewController?.view else {
            return
        }
        
        rootView.findScrollView()?.scrollToTop()
    }
    
    func navigateToSearch(for mealType: MealType) {
        selectedMealType = mealType
        searchViewModel.loadingBookmarks()
        
        Task {
            await searchViewModel.loadBookmarksSearchView(for: mealType)
        }
    }
    
    func clearDayAlert(for date: Date) -> Alert {
        Alert(
            title: Text("Clear Day"),
            message: Text("Delete all food logs for \(formattedDateForAlert())?"),
            primaryButton: .destructive(Text("Delete All")) {
                self.clearDay()
            },
            secondaryButton: .cancel(Text("Cancel"))
        )
    }
    
    func clearMealTypeAlert() -> Alert {
        guard let mealType = mealTypeToClear else {
            return Alert(title: Text("Error"))
        }
        
        return Alert(
            title: Text("Clear Meal type"),
            message: Text("Delete all entries in \(mealType.rawValue)"),
            primaryButton: .destructive(Text("Delete All")) {
                self.clearMealType(mealType)
                self.mealTypeToClear = nil
            },
            secondaryButton: .cancel(Text("Cancel")) {
                self.mealTypeToClear = nil
            }
        )
    }
    
    var currentIntake: String {
        (intake.doubleValue ?? 0).asWhole()
    }
    
    func filteredItems(for mealType: MealType) -> [MealItem] {
        filteredMealItems(for: mealType, on: date)
    }
    
    func hasItems(for mealType: MealType) -> Bool {
        !filteredItems(for: mealType).isEmpty
    }
    
    func totalCaloriesText(for mealType: MealType) -> String {
        totalCalories(for: mealType).asWhole()
    }
    
    func canDisplayIntake() -> Bool {
        displayIntake && !intake.isEmpty
    }
    
    func intakePercentageText(for mealType: MealType) -> String {
        totalIntakePercentage(for: mealType)
    }
    
    func isExpandedBinding(for mealType: MealType) -> Binding<Bool> {
        Binding(
            get: { self.expandedSections[mealType] ?? false },
            set: { self.expandedSections[mealType] = $0 }
        )
    }
    
    func isExpanded(for mealType: MealType) -> Bool {
        expandedSections[mealType] == true
    }
    
    func entryCountText(for mealType: MealType) -> String {
        let count = filteredItems(for: mealType).count
        return count == 1 ? "1 entry" : "\(count) entries"
    }
}

extension MainViewModel: MainViewModelProtocol {
    func resetDateToToday() {
        date = Date()
    }
    
    func setSectionExpanded(for mealType: MealType, to isExpanded: Bool) {
        expandedSections[mealType] = isExpanded
    }
    
    func setDisplayIntake(_ value: Bool) {
        displayIntake = value
    }
    
    func updateIntake(to value: String) {
        intake = (Double(value) ?? 0).asWhole(grouping: false)
    }
}

#Preview {
    PreviewContentView.contentView
}
