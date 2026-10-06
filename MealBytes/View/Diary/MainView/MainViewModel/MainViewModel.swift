//
//  MainViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/03/2025.
//

import SwiftUI
import FirebaseCore

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
    @Published var energyUnit: EnergyUnit = .kcal
    @Published var appError: AppError?
    @Published var uniqueId: UUID?
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
                self.mealItems = Dictionary(
                    grouping: mealItems,
                    by: { $0.mealType }
                )
                
                recalculateNutrients(for: date)
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
        
        if let index = items.firstIndex(
            where: { $0.id == updatedItem.id
                && calendar.isDate($0.date, inSameDayAs: date)
            }
        ) {
            mealItems[mealType]?[index] = updatedItem
        }
        
        recalculateNutrients(for: date)
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
    func deleteMealItemMainView(
        with id: UUID,
        for mealType: MealType,
        animated: Bool = true
    ) {
        let itemToDelete = mealItems[mealType]?.first(where: { $0.id == id })
        
        let update = {
            var newMealItems = self.mealItems
            newMealItems[mealType]?.removeAll { $0.id == id }
            self.mealItems = newMealItems
            
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
            
            recalculateNutrients(for: date)
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
            
            recalculateNutrients(for: date)
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
    
    // MARK: - Load Goals Disabled
    private func loadDisplayGoalsMainView() async {
        do {
            let display = try await firestore.loadDisplayGoalsFirestore()
            await MainActor.run {
                displayGoals = display
            }
        } catch {
            await MainActor.run {
                self.appError = .network
            }
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
            await MainActor.run {
                appError = .network
            }
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
            await MainActor.run {
                self.appError = .network
            }
        }
    }
    
    // MARK: - Set Energy Unit
    func setEnergyUnit(_ unit: EnergyUnit) async {
        await MainActor.run {
            energyUnit = unit
        }
        
        do {
            try await firestore.saveEnergyUnitFirestore(unit.rawValue)
        } catch {
            await MainActor.run {
                appError = .network
            }
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
            await MainActor.run {
                self.appError = .network
            }
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
            await MainActor.run {
                appError = .network
            }
        }
    }
    
    // MARK: - Intake from VM
    private func currentIntakeFromVM(for source: String? = nil) -> String {
        let source = source ?? intakeSource
        
        switch source {
        case IntakeSource.personal.rawValue:
            if let personal = goalsViewModel.personalIntakeViewModel
                as? PersonalIntakeViewModel {
                return personal.calculatedPersonalIntake
            }
        case IntakeSource.macros.rawValue:
            if let macros = goalsViewModel.macrosIntakeViewModel
                as? MacrosIntakeViewModel {
                return macros.calories
            }
        case IntakeSource.custom.rawValue:
            if let custom = goalsViewModel.customIntakeViewModel
                as? CustomIntakeViewModel {
                return custom.calories
            }
        default:
            break
        }
        return ""
    }
    
    private func computeNutrientTargets(
        for source: String
    ) -> NutrientTargets {
        let intakeValue = currentIntakeFromVM(for: source).doubleValue ?? 0
        
        switch source {
        case IntakeSource.personal.rawValue:
            guard intakeValue > 0 else { return NutrientTargets() }
            guard let personal = goalsViewModel.personalIntakeViewModel
                    as? PersonalIntakeViewModel else {
                return NutrientTargets()
            }
            return NutrientTargets(
                calories: intakeValue,
                fat: (intakeValue * personal.fatPercentage) / 9,
                carbs: (intakeValue * personal.carbsPercentage) / 4,
                protein: (intakeValue * personal.proteinPercentage) / 4
            )
            
        case IntakeSource.macros.rawValue:
            guard let macros = goalsViewModel.macrosIntakeViewModel
                    as? MacrosIntakeViewModel else {
                return NutrientTargets()
            }
            return NutrientTargets(
                calories: intakeValue,
                fat: macros.fat.doubleValue ?? 0,
                carbs: macros.carbohydrate.doubleValue ?? 0,
                protein: macros.protein.doubleValue ?? 0
            )
            
        case IntakeSource.custom.rawValue:
            guard let custom = goalsViewModel.customIntakeViewModel
                    as? CustomIntakeViewModel else {
                return NutrientTargets()
            }
            return NutrientTargets(
                calories: intakeValue,
                fat: custom.fat.doubleValue ?? 0,
                carbs: custom.carbohydrate.doubleValue ?? 0,
                protein: custom.protein.doubleValue ?? 0
            )
            
        default:
            return NutrientTargets()
        }
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
        resetDateToToday()
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
    func resetDateToToday() {
        date = Date()
    }
    
    func setSectionExpanded(for mealType: MealType, to isExpanded: Bool) {
        expandedSections[mealType] = isExpanded
    }
}

#Preview {
    PreviewContentView.contentView
}
