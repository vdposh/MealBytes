//
//  MainViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/03/2025.
//

import SwiftUI
import FirebaseCore
import OSLog

protocol MainViewModelProtocol {
    var date: Date { get set }
    var displayGoals: Bool { get }
    var energyUnit: EnergyUnit { get }
    var intakeSource: String { get }
    
    func loadMainData() async
    func saveCurrentIntakeMainView(source: String) async
    func setDisplayGoals(_ display: Bool) async
    func setEnergyUnit(_ unit: EnergyUnit) async
    func filteredMealItems(for mealType: MealType, on date: Date) -> [MealItem]
    func addMealItemMainView(_ item: MealItem, to: MealType, for: Date)
    func updateMealItemMainView(_ item: MealItem, for: MealType, on: Date)
    func deleteMealItemMainView(with id: UUID, for: MealType, animated: Bool)
    func setSectionExpanded(for mealType: MealType, to isExpanded: Bool)
    func formattedDate() -> String
    func resetMainState()
}

final class MainViewModel: ObservableObject {
    @Published var date = Date() {
        didSet {
            handleDateChange(from: oldValue, to: date)
        }
    }
    @Published var mealItemsByDate: [String: [MealType: [MealItem]]] = [:]
    @Published var nutrientSummaries: [NutrientType: Double]
    @Published var expandedSections: [MealType: Bool] = [:]
    @Published var energyUnit: EnergyUnit = .kcal
    @Published var selectedMealType: MealType?
    @Published var selectedFoodItem: MealItem?
    @Published var mealTypeToClear: MealType?
    @Published var intakeSource: String = ""
    @Published var nutrientTargets = NutrientTargets()
    @Published var showDatePicker: Bool = false
    @Published var showGoals: Bool = false
    @Published var displayGoals: Bool = true
    @Published var showNutrientTotals: Bool = false
    @Published var showClearDayAlert: Bool = false
    @Published var showClearMealTypeAlert: Bool = false
    @Published var isExpanded: Bool = false
    @Published var isChangingDate: Bool = false
    
    let calendar = Calendar.current
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    lazy var searchViewModel: SearchViewModelProtocol = SearchViewModel(
        mainViewModel: self
    )
    lazy var goalsViewModel = GoalsViewModel(
        mainViewModel: self,
        macrosIntakeViewModel: MacrosIntakeViewModel(mainViewModel: self),
        personalIntakeViewModel: PersonalIntakeViewModel(mainViewModel: self),
        customIntakeViewModel: CustomIntakeViewModel(mainViewModel: self)
    )
    
    init() {
        var summaries = [NutrientType: Double]()
        var sections = [MealType: Bool]()
        
        NutrientType.allCases.forEach { summaries[$0] = 0.0 }
        MealType.allCases.forEach { sections[$0] = true }
        
        self.nutrientSummaries = summaries
        self.expandedSections = sections
    }
    
    // MARK: - Load Main Data
    func loadMainData() async {
        async let mealItemsTask: () = loadMealItemsMainView()
        async let displayGoalsTask: () = loadDisplayGoalsMainView()
        async let energyUnitTask: () = loadEnergyUnitMainView()
        async let intakeTask: () = loadIntakeMainView()
        async let bookmarksTask: () = searchViewModel.loadSearchViewData()
        
        _ = await (
            mealItemsTask,
            displayGoalsTask,
            intakeTask,
            bookmarksTask,
            energyUnitTask
        )
        
        await goalsViewModel.loadGoalsData()
        
        await MainActor.run {
            self.nutrientTargets = computeNutrientTargets(for: intakeSource)
        }
    }
    
    // MARK: - Load Meal Item
    private func loadMealItemsMainView() async {
        do {
            let mealItems = try await firestore.loadMealItemsFirestore()
            
            await MainActor.run {
                var grouped: [String: [MealType: [MealItem]]] = [:]
                
                for item in mealItems {
                    let key = dateKey(for: item.date)
                    grouped[key, default: [:]][item.mealType, default: []]
                        .append(item)
                }
                
                self.mealItemsByDate = grouped
                recalculateNutrients(for: date)
            }
        } catch {
            Logger.main.error("loadMealItems failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Add Meal Item
    func addMealItemMainView(
        _ item: MealItem,
        to mealType: MealType,
        for date: Date
    ) {
        let key = dateKey(for: date)
        mealItemsByDate[key, default: [:]][mealType, default: []].append(item)
        expandedSections[mealType] = true
        
        recalculateNutrients(for: date)
    }
    
    // MARK: - Update Meal Item
    func updateMealItemMainView(
        _ updatedItem: MealItem,
        for mealType: MealType,
        on date: Date
    ) {
        let key = dateKey(for: date)
        guard var items = mealItemsByDate[key]?[mealType] else { return }
        
        if let index = items.firstIndex(where: { $0.id == updatedItem.id }) {
            items[index] = updatedItem
            mealItemsByDate[key]?[mealType] = items
        }
        
        recalculateNutrients(for: date)
    }
    
    // MARK: - Move Meal Item
    func moveMealItem(_ item: MealItem, to newMealType: MealType) {
        guard item.mealType != newMealType else { return }
        
        let key = dateKey(for: item.date)
        
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
            mealItemsByDate[key]?[item.mealType]?
                .removeAll { $0.id == item.id }
            mealItemsByDate[key]?[newMealType, default: []]
                .append(updatedItem)
            expandedSections[newMealType] = true
        }
        
        Task {
            do {
                try await firestore.updateMealItemFirestore(updatedItem)
            } catch {
                Logger.main.error("moveMealItem failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Delete Meal Item
    func deleteMealItemMainView(
        with id: UUID,
        for mealType: MealType,
        animated: Bool = true
    ) {
        let key = dateKey(for: date)
        let itemToDelete = mealItemsByDate[key]?[mealType]?
            .first(where: { $0.id == id })
        
        let update = {
            self.mealItemsByDate[key]?[mealType]?.removeAll { $0.id == id }
            self.recalculateNutrients(for: self.date)
        }
        
        if animated {
            withAnimation {
                update()
            }
        } else {
            update()
        }
        
        Task {
            guard let itemToDelete else { return }
            
            do {
                try await firestore.deleteMealItemFirestore(itemToDelete)
            } catch {
                Logger.main.error("deleteMealItemMainView failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Clear Day
    func clearDay() {
        let dateToClear = date
        let key = dateKey(for: dateToClear)
        
        withAnimation {
            mealItemsByDate.removeValue(forKey: key)
            recalculateNutrients(for: date)
        }
        
        Task {
            do {
                try await firestore.deleteMealItemsFirestore(on: dateToClear)
            } catch {
                Logger.main.error("clearDay failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Clear Meal Type
    func clearMealType(_ mealType: MealType) {
        let dateToClear = date
        let key = dateKey(for: dateToClear)
        
        let itemsToDelete = filteredMealItems(for: mealType, on: dateToClear)
        
        withAnimation {
            mealItemsByDate[key]?[mealType] = []
            recalculateNutrients(for: date)
        }
        
        Task {
            do {
                for item in itemsToDelete {
                    try await firestore.deleteMealItemFirestore(item)
                }
            } catch {
                Logger.main.error("clearDay failed: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Load Goals Disabled
    private func loadDisplayGoalsMainView() async {
        do {
            let display = try await firestore.loadDisplayGoalsFirestore()
            await MainActor.run {
                displayGoals = display
            }
        } catch {
            Logger.main.error("loadDisplayGoalsMainView failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Set Goals Disabled
    func setDisplayGoals(_ display: Bool) async {
        await MainActor.run {
            displayGoals = display
        }
        
        do {
            try await firestore.saveDisplayGoalsFirestore(display)
        } catch {
            Logger.main.error("setDisplayGoals failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Load Energy Unit
    private func loadEnergyUnitMainView() async {
        do {
            let unit = try await firestore.loadEnergyUnitFirestore()
            await MainActor.run {
                energyUnit = EnergyUnit(rawValue: unit) ?? .kcal
            }
        } catch {
            Logger.main.error("loadEnergyUnitMainView failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Set Energy Unit
    func setEnergyUnit(_ unit: EnergyUnit) async {
        await MainActor.run {
            energyUnit = unit
            goalsViewModel.energyUnitChanged(to: unit)
        }
        
        do {
            try await firestore.saveEnergyUnitFirestore(unit.rawValue)
        } catch {
            Logger.main.error("setEnergyUnit failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Load Intake
    private func loadIntakeMainView() async {
        do {
            let current = try await firestore.loadCurrentIntakeFirestore()
            
            await MainActor.run {
                self.intakeSource = current.source
            }
        } catch {
            Logger.main.error("loadIntakeMainView failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Save Current Intake
    func saveCurrentIntakeMainView(source: String) async {
        do {
            let intakeData = CurrentIntake(source: source)
            
            try await firestore.saveCurrentIntakeFirestore(intakeData)
            
            let newTargets = computeNutrientTargets(for: source)
            
            await MainActor.run {
                self.intakeSource = source
                self.nutrientTargets = newTargets
            }
        } catch {
            Logger.main.error("saveCurrentIntakeMainView failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Current Intake
    private func computeNutrientTargets(
        for source: String
    ) -> NutrientTargets {
        goalsViewModel.nutrientTargets(for: source)
    }
    
    // MARK: - Calculation
    func calorieProgress() -> Double? {
        guard nutrientTargets.calories > 0 else { return nil }
        let calories = totalCalories()
        return calories / nutrientTargets.calories
    }
    
    func macroProgress(for type: NutrientType) -> Double? {
        let current = totalNutrients()
        
        switch type {
        case .fat:
            guard nutrientTargets.fat > 0 else { return nil }
            return current.fat / nutrientTargets.fat
        case .carbohydrate:
            guard nutrientTargets.carbs > 0 else { return nil }
            return current.carbs / nutrientTargets.carbs
        case .protein:
            guard nutrientTargets.protein > 0 else { return nil }
            return current.protein / nutrientTargets.protein
        default:
            return nil
        }
    }
    
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
    
    // MARK: - Calculation (Nutrients)
    private func recalculateNutrients(for date: Date) {
        let key = dateKey(for: date)
        let dayItems = mealItemsByDate[key] ?? [:]
        
        nutrientSummaries = dayItems.values.reduce(
            into: [NutrientType: Double]()
        ) { result, mealList in
            mealList.forEach { item in
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
        let key = dateKey(for: date)
        return mealItemsByDate[key]?[mealType] ?? []
    }
    
    var hasMealItems: Bool {
        let key = dateKey(for: date)
        return !(mealItemsByDate[key]?.values.allSatisfy(\.isEmpty) ?? true)
    }
    
    func hasMealItemsForMealType(
        for mealType: MealType,
        on date: Date
    ) -> Bool {
        !filteredMealItems(for: mealType, on: date).isEmpty
    }
    
    // MARK: - Filtered Nutrients
    var filteredNutrientValues: [NutrientValue] {
        NutrientValueProvider().fromSummary(
            nutrientSummaries,
            energyUnit: energyUnit
        )
    }
    
    func formattedMealText(for mealItem: MealItem) -> String {
        let formattedAmount = mealItem.amount.asDecimal()
        let measurement = mealItem.measurementDescription
        let servingSize = mealItem.nutrients[.servingSize] ?? 0
        let amountValue = mealItem.amount
        
        if formattedAmount.isEmpty || amountValue == 0 {
            if measurement == "g" {
                return "grams"
            }
            return measurement
        }
        
        let displayMeasurement: String
        if measurement == "g" {
            displayMeasurement = "g"
        } else if measurement == "ml" {
            displayMeasurement = "ml"
        } else if measurement.starts(with: "serving") {
            displayMeasurement = amountValue == 1 ? "serving" : "servings"
        } else {
            displayMeasurement = measurement.pluralized(for: amountValue)
        }
        
        let unit = mealItem.portionUnit
        
        if servingSize == 0 {
            return "\(formattedAmount) \(displayMeasurement)"
        }
        
        if measurement == "g" || measurement == "ml" {
            return "\(formattedAmount) \(unit)"
        }
        
        let totalSize = servingSize * amountValue
        return "\(formattedAmount) \(displayMeasurement) (\(totalSize.asDecimal()) \(unit))"
    }
    
    // MARK: - Date
    private func dateKey(for date: Date) -> String {
        date.formatted(.iso8601.year().month().day())
    }
    
    func formattedDate() -> String {
        if calendar.isDate(date, equalTo: Date(), toGranularity: .year) {
            return date.formatted(
                .dateTime.weekday(.wide).day().month(.wide)
            )
        } else {
            return date.formatted(
                .dateTime.weekday(.abbreviated).day().month(.wide).year()
            )
        }
    }
    
    private func handleDateChange(from oldDate: Date, to newDate: Date) {
        guard !calendar.isDate(oldDate, inSameDayAs: newDate) else { return }
        
        recalculateNutrients(for: newDate)
        expandAllSections()
        isExpanded = false
    }
    
    func setDate(_ newDate: Date) {
        guard !calendar.isDate(date, inSameDayAs: newDate) else { return }
        
        isChangingDate = true
        
        withAnimation {
            date = newDate
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.isChangingDate = false
        }
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
    
    // MARK: - Reset State
    func resetMainState() {
        selectedMealType = nil
        
        expandAllSections()
        setDate(Date())
        goalsViewModel.clearGoalsView()
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
        searchViewModel.displaySearchViewData(for: mealType)
        searchViewModel.resetQuery()
    }
    
    func clearDayAlert(for date: Date) -> Alert {
        Alert(
            title: Text("Clear Day"),
            message: Text(
                "Delete all food logs for \(formattedDateForAlert())?"
            ),
            primaryButton: .destructive(Text("Delete All")) {
                self.clearDay()
            },
            secondaryButton: .cancel()
        )
    }
    
    func clearMealTypeAlert() -> Alert {
        guard let mealType = mealTypeToClear else {
            return Alert(title: Text("Error"))
        }
        
        return Alert(
            title: Text("Clear Meal Type"),
            message: Text("Delete all entries in \(mealType.rawValue)"),
            primaryButton: .destructive(Text("Delete All")) {
                self.clearMealType(mealType)
                self.mealTypeToClear = nil
            },
            secondaryButton: .cancel() {
                self.mealTypeToClear = nil
            }
        )
    }
    
    func filteredItems(for mealType: MealType) -> [MealItem] {
        filteredMealItems(for: mealType, on: date)
    }
    
    func hasItems(for mealType: MealType) -> Bool {
        !filteredItems(for: mealType).isEmpty
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
    func setSectionExpanded(for mealType: MealType, to isExpanded: Bool) {
        expandedSections[mealType] = isExpanded
    }
}

#Preview {
    PreviewContentView.contentView
}
