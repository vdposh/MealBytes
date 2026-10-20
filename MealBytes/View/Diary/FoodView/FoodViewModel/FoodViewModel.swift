//
//  FoodViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI
import FirebaseCore

final class FoodViewModel: ObservableObject {
    @Published var selectedServing: Serving?
    @Published var appError: AppError?
    @Published var selectedDate: Date
    @Published var amount: String = ""
    @Published var originalAmount: String = ""
    @Published var isLoading: Bool = true
    @Published var isError: Bool = false
    @Published var isBookmarkFilled: Bool = false
    @Published var hasLoadedDetails = false
    @Published var showDatePicker: Bool = false
    @Published var foodDetail: FoodDetail? {
        didSet {
            self.selectedServing = nil
        }
    }
    
    private let originalMealType: MealType
    private let originalCreatedAt: Date
    private let originalDate: Date
    private let originalMealItemId: UUID
    private let initialMeasurementDescription: String
    private let isEditingMealItem: Bool
    private var didChangeMealType: Bool {
        mealType != originalMealType
    }
    
    let food: Food
    var mealType: MealType
    
    private let fatSecretManager: FatSecretManagerProtocol = FatSecretManager()
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private var searchViewModel: SearchViewModelProtocol
    let mainViewModel: MainViewModelProtocol
    
    init(
        food: Food,
        mealType: MealType,
        searchViewModel: SearchViewModelProtocol,
        mainViewModel: MainViewModelProtocol,
        initialAmount: String = "",
        initialMeasurementDescription: String = "",
        isEditingMealItem: Bool = false,
        originalCreatedAt: Date = Date(),
        originalMealItemId: UUID? = nil,
        originalDate: Date? = nil
    ) {
        self.food = food
        self.selectedDate = originalDate ?? mainViewModel.date
        self.mealType = mealType
        self.originalMealType = mealType
        self.searchViewModel = searchViewModel
        self.mainViewModel = mainViewModel
        self.amount = initialAmount
        self.initialMeasurementDescription = initialMeasurementDescription
        self.isEditingMealItem = isEditingMealItem
        self.originalCreatedAt = originalCreatedAt
        self.originalMealItemId = originalMealItemId ?? UUID()
        self.originalDate = originalDate ?? mainViewModel.date
    }
    
    // MARK: - Fetch Food Details
    @MainActor
    func fetchFoodDetails() async {
        isLoading = true
        
        await searchViewModel.loadBookmarksSearchView(for: mealType)
        
        do {
            let fetchedFoodDetail = try await fatSecretManager
                .fetchFoodDetails(foodId: food.searchFoodId)
            
            self.foodDetail = fetchedFoodDetail
            
            if isEditingMealItem {
                let servingDescription = initialMeasurementDescription
                
                if let serving = fetchedFoodDetail.servings.serving.first(
                    where: { $0.measurementDescription == servingDescription }
                ) {
                    selectedServing = serving
                } else {
                    selectedServing = fetchedFoodDetail.servings.serving.first
                }
            } else {
                let metadata = searchViewModel
                    .foodMetadataDict[food.searchFoodId]
                let servingDescription = metadata?
                    .servingDescription ?? initialMeasurementDescription
                
                if let metadata, let value = Double(metadata.amount) {
                    amount = value.asDecimal(grouping: false)
                }
                
                if let serving = fetchedFoodDetail.servings.serving.first(
                    where: { $0.measurementDescription == servingDescription }
                ) {
                    selectedServing = serving
                } else {
                    selectedServing = fetchedFoodDetail.servings.serving.first
                }
                
                if metadata == nil {
                    setAmount(for: selectedServing)
                }
            }
            
            self.isBookmarkFilled = searchViewModel
                .isBookmarkedSearchView(food)
            
        } catch {
            self.appError = error as? AppError ?? .networkRefresh
            isError = true
        }
        
        isLoading = false
    }
    
    func loadFoodData() async {
        guard !hasLoadedDetails else { return }
        
        await MainActor.run {
            hasLoadedDetails = true
        }
        await fetchFoodDetails()
    }
    
    // MARK: - Add Food Item
    func addMealItemFoodView(in section: MealType, for date: Date) async {
        let nutrients = storageNutrients
        let newItem = MealItem(
            foodId: food.searchFoodId,
            foodName: food.searchFoodName,
            portionUnit: selectedServing?.measurementDescription == "ml"
            ? "ml"
            : selectedServing?.metricServingUnit ?? "",
            nutrients: nutrients,
            measurementDescription:
                selectedServing?.measurementDescription ?? "",
            amount: amount.doubleValue ?? 0,
            date: date, mealType: mealType
        )
        
        await MainActor.run {
            mainViewModel.addMealItemMainView(newItem, to: section, for: date)
        }
        
        do {
            try await firestore.addMealItemFirestore(newItem)
            
            await searchViewModel.addToHistory(food, for: mealType)
            
            if let selectedServing {
                let adjusted = getAdjustedNutrientsForStorage()
                
                let metadata = FoodMetadata(
                    foodId: food.searchFoodId,
                    foodName: food.searchFoodName,
                    mealType: mealType,
                    amount: String(amount.doubleValue ?? 0),
                    servingDescription: selectedServing.measurementDescription,
                    calories: adjusted.calories,
                    fat: adjusted.fat,
                    carbs: adjusted.carbs,
                    protein: adjusted.protein,
                    formattedText: formattedMealText(
                        for: selectedServing,
                        amount: amount
                    ),
                    measurementDescription: selectedServing
                        .measurementDescription,
                    metricServingAmount: selectedServing.metricServingAmount,
                    metricServingUnit: selectedServing.metricServingUnit,
                )
                
                try await firestore
                    .saveFoodMetadata(metadata, for: mealType)
                
                await MainActor.run {
                    searchViewModel
                        .updateMetadata(metadata, for: mealType)
                }
            }
            
        } catch {
            await MainActor.run {
                appError = .network
            }
        }
        
        searchViewModel.triggerFoodAlert()
    }
    
    // MARK: - Update Food Item
    func updateMealItemFoodView(for date: Date) async {
        guard let selectedServing else { return }
        
        let createdAt = didChangeMealType ? Date() : originalCreatedAt
        let didChangeDate = !Calendar.current.isDate(
            date,
            inSameDayAs: originalDate
        )
        
        let nutrients = storageNutrients
        
        let updatedMealItem = MealItem(
            id: originalMealItemId,
            foodId: food.searchFoodId,
            foodName: food.searchFoodName,
            portionUnit: selectedServing.measurementDescription == "ml"
            ? "ml"
            : selectedServing.metricServingUnit,
            nutrients: nutrients,
            measurementDescription: selectedServing.measurementDescription,
            amount: amount.doubleValue ?? 0,
            date: date,
            mealType: mealType,
            createdAt: createdAt
        )
        
        do {
            if originalMealType == mealType && !didChangeDate {
                await MainActor.run {
                    mainViewModel.updateMealItemMainView(
                        updatedMealItem,
                        for: mealType,
                        on: date
                    )
                }
                
                try await firestore.updateMealItemFirestore(updatedMealItem)
            } else {
                await MainActor.run {
                    mainViewModel.deleteMealItemMainView(
                        with: originalMealItemId,
                        for: originalMealType,
                        on: originalDate,
                        animated: false
                    )
                }
                
                await MainActor.run {
                    mainViewModel.addMealItemMainView(
                        updatedMealItem,
                        to: mealType,
                        for: date
                    )
                    mainViewModel.setSectionExpanded(
                        for: originalMealType,
                        to: true
                    )
                }
                
                try await firestore.updateMealItemFirestore(updatedMealItem)
            }
        } catch {
            await MainActor.run {
                appError = .network
            }
        }
    }
    
    // MARK: - Delete Food Item
    func deleteMealItemFoodView() {
        mainViewModel.deleteMealItemMainView(
            with: originalMealItemId,
            for: originalMealType,
            on: originalDate,
            animated: false
        )
    }
    
    // MARK: - Bookmark Management
    func toggleBookmarkFoodView() async {
        searchViewModel.displaySearchViewData(for: mealType)
        
        await MainActor.run {
            isBookmarkFilled.toggle()
        }
        
        await searchViewModel.toggleBookmarkSearchView(for: food)
        
        guard isBookmarkFilled,
              let selectedServing else { return }
        
        let adjusted = getAdjustedNutrientsForStorage()
        
        let metadata = FoodMetadata(
            foodId: food.searchFoodId,
            foodName: food.searchFoodName,
            mealType: mealType,
            amount: String(amount.doubleValue ?? 0),
            servingDescription: selectedServing.measurementDescription,
            calories: adjusted.calories,
            fat: adjusted.fat,
            carbs: adjusted.carbs,
            protein: adjusted.protein,
            formattedText: formattedMealText(
                for: selectedServing,
                amount: amount
            ),
            measurementDescription: selectedServing.measurementDescription,
            metricServingAmount: selectedServing.metricServingAmount,
            metricServingUnit: selectedServing.metricServingUnit,
        )
        
        await MainActor.run {
            searchViewModel.updateMetadata(metadata, for: mealType)
        }
        
        do {
            try await firestore.saveFoodMetadata(metadata, for: mealType)
            
            await MainActor.run {
                searchViewModel
                    .foodMetadataDict[food.searchFoodId] = metadata
            }
        } catch {
            await MainActor.run {
                appError = .network
            }
        }
    }
    
    func updateBookmarkState() {
        isBookmarkFilled = searchViewModel.isBookmarked(food, for: mealType)
    }
    
    // MARK: - Change MealType
    func updateMealType(_ newMealType: MealType) {
        mealType = newMealType
        updateBookmarkState()
    }
    
    // MARK: - Serving Selection and Amount Setting
    func updateServing(_ serving: Serving) {
        self.selectedServing = serving
        setAmount(for: serving)
    }
    
    private func setAmount(for serving: Serving?) {
        guard let serving else {
            self.amount = ""
            return
        }
        
        if serving.isMetricMeasurement {
            self.amount = "100"
        } else {
            self.amount = "1"
        }
    }
    
    // MARK: - Serving Description
    func servingDescription(
        for serving: Serving,
        showUnit: Bool = false
    ) -> String {
        let metricUnit = serving.metricServingUnit
        let metricAmountFormatted = serving.metricServingAmount.asDecimal()
        var description = serving.measurementDescription
        
        if serving.isMetricMeasurement {
            if description == "g" {
                return UnitNutrients.g.unitDescription(for: 0, full: true)
            } else if description == "ml" {
                return UnitNutrients.ml.unitDescription(for: 0)
            }
            return description
        }
        
        if description.hasPrefix("serving"),
           let range = description.range(
            of: #"serving\s*\([^)]+\)"#,
            options: .regularExpression
           ) {
            description.replaceSubrange(range, with: "serving")
        }
        
        if showUnit && serving.metricServingAmount > 0 {
            return "\(description) (\(metricAmountFormatted) \(metricUnit))"
        }
        
        return description
    }
    
    func formattedMealText(for serving: Serving, amount: String) -> String {
        MealItemTextFormatter.format(
            amountValue: amount.doubleValue ?? 0,
            measurement: serving.measurementDescription,
            servingSize: serving.metricServingAmount,
            unit: serving.metricServingUnit
        )
    }
    
    // MARK: - Button States
    var canAddFood: Bool {
        let normalized = amount.trimmedLeadingZeros
        return normalized.isValidNumericInput()
    }
    
    // MARK: - Nutrient Calculation
    private func calculateSelectedAmountValue() -> Double {
        guard let selectedServing, canAddFood else { return 0 }
        
        let amountValue = amount.doubleValue ?? 0
        
        return calculateBaseAmountValue(
            amountValue,
            serving: selectedServing
        )
    }
    
    private func calculateBaseAmountValue(
        _ amount: Double,
        serving: Serving
    ) -> Double {
        if amount.isZero {
            return 0
        }
        
        if serving.isMetricMeasurement {
            return amount * 0.01
        } else {
            return amount
        }
    }
    
    var nutrientValues: [NutrientValue] {
        guard let selectedServing else { return [] }
        
        let unit = energyUnit
        
        return NutrientValueProvider()
            .fromServing(selectedServing)
            .filter { $0.type != .servingSize }
            .map { value in
                let rawValue = value.value * calculateSelectedAmountValue()
                let isCalories = value.type == .calories
                
                return NutrientValue(
                    type: value.type,
                    value: isCalories
                    ? unit.fromKcal(kcal: rawValue)
                    : rawValue,
                    isSubValue: value.isSubValue,
                    unit: isCalories
                    ? unit.unitNutrient
                    : value.unit
                )
            }
    }
    
    private var storageNutrients: [NutrientType: Double] {
        guard let selectedServing else { return [:] }
        
        return NutrientValueProvider()
            .fromServing(selectedServing)
            .reduce(into: [NutrientType: Double]()) { result, value in
                let scaled = value.value * calculateSelectedAmountValue()
                result[value.type] = value.type == .servingSize
                ? value.value
                : scaled
            }
    }
    
    var servingUnit: String {
        guard let serving = selectedServing else { return "" }
        
        let scaledAmount = serving
            .metricServingAmount * calculateSelectedAmountValue()
        let unit = UnitNutrients(rawValue: serving.metricServingUnit) ?? .empty
        
        if scaledAmount.isZero {
            return ""
        }
        
        return scaledAmount
            .asDecimal(unit: unit.unitDescription(for: scaledAmount))
    }
    
    func getAdjustedNutrientsForStorage() -> (
        calories: Double,
        fat: Double,
        carbs: Double,
        protein: Double
    ) {
        guard selectedServing != nil else {
            return (0, 0, 0, 0)
        }
        
        let nutrients = NutrientValueProvider()
            .fromServing(selectedServing!)
            .map { value in
                NutrientValue(
                    type: value.type,
                    value: value.value * calculateSelectedAmountValue(),
                    isSubValue: value.isSubValue,
                    unit: value.unit
                )
            }
        
        let calories = nutrients.first(
            where: { $0.type == .calories
            })?.value ?? 0
        let fat = nutrients.first(
            where: { $0.type == .fat
            })?.value ?? 0
        let carbs = nutrients.first(
            where: { $0.type == .carbohydrate
            })?.value ?? 0
        let protein = nutrients.first(
            where: { $0.type == .protein
            })?.value ?? 0
        
        return (calories, fat, carbs, protein)
    }
    
    // MARK: - Keyboard
    func normalizeAmount() {
        amount = amount.trimmedLeadingZeros
    }
    
    // MARK: - Focus
    func handleAmountFocusChange(from oldValue: Bool, to newValue: Bool) {
        if newValue {
            originalAmount = amount
            amount = ""
        } else {
            if let newAmount = amount.doubleValue,
               newAmount > 0 {
                originalAmount = amount
            } else {
                amount = originalAmount
            }
        }
    }
    
    // MARK: - UI Helper
    var navigationTitleText: String {
        isEditingMealItem ? "Edit Entry" : "\(mealType.rawValue) Entry"
    }
    
    var viewState: FoodViewState {
        if let error = appError {
            return .error(error)
        } else if isLoading {
            return .loading
        } else {
            return .loaded
        }
    }
    
    var shouldShowToolbar: Bool {
        if case .error = viewState {
            return false
        }
        
        return true
    }
    
    var energyUnit: EnergyUnit {
        mainViewModel.energyUnit
    }
    
    var viewMode: FoodViewMode {
        isEditingMealItem ? .fromMainView : .fromSearchView
    }
    
    enum FoodViewState {
        case loading
        case error(AppError)
        case loaded
    }
    
    enum FoodViewMode {
        case fromSearchView
        case fromMainView
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
