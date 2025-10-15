//
//  FoodViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI
import Combine
import FirebaseCore

final class FoodViewModel: ObservableObject {
    @Published var selectedServing: Serving?
    @Published var amount: String = ""
    @Published var originalAmount: String = ""
    @Published var appError: AppError?
    @Published var unit: MeasurementUnit = .grams
    @Published var isLoading: Bool = true
    @Published var isError: Bool = false
    @Published var isBookmarkFilled: Bool = false
    @Published var hasLoadedDetails = false
    @Published var foodDetail: FoodDetail? {
        didSet {
            self.selectedServing = nil
        }
    }
    
    private let formatter = Formatter()
    private let originalMealType: MealType
    private let originalCreatedAt: Date
    private let originalMealItemId: UUID
    private let initialMeasurementDescription: String
    private let showSaveRemoveButton: Bool
    private var didChangeMealType: Bool {
        mealType != originalMealType
    }
    
    let food: Food
    var mealType: MealType
    
    private let fatSecretManager: FatSecretManagerProtocol = FatSecretManager()
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let searchViewModel: SearchViewModelProtocol
    let mainViewModel: MainViewModelProtocol
    
    init(
        food: Food,
        mealType: MealType,
        searchViewModel: SearchViewModelProtocol,
        mainViewModel: MainViewModelProtocol,
        initialAmount: String = "",
        initialMeasurementDescription: String = "",
        showSaveRemoveButton: Bool = false,
        originalCreatedAt: Date = Date(),
        originalMealItemId: UUID? = nil
    ) {
        let roundedAmount = Formatter().formattedValue(
            Double(initialAmount),
            unit: .empty,
            alwaysRoundUp: false
        )
        self.food = food
        self.mealType = mealType
        self.originalMealType = mealType
        self.searchViewModel = searchViewModel
        self.mainViewModel = mainViewModel
        self.amount = roundedAmount
        self.initialMeasurementDescription = initialMeasurementDescription
        self.showSaveRemoveButton = showSaveRemoveButton
        self.originalCreatedAt = originalCreatedAt
        self.originalMealItemId = originalMealItemId ?? UUID()
    }
    
    // MARK: - Fetch Food Details
    @MainActor
    func fetchFoodDetails() async {
        isLoading = true
        
        await searchViewModel.loadBookmarksSearchView(for: mealType)
        self.isBookmarkFilled = searchViewModel.isBookmarkedSearchView(food)
        
        do {
            let fetchedFoodDetail = try await fatSecretManager
                .fetchFoodDetails(foodId: food.searchFoodId)
            self.foodDetail = fetchedFoodDetail
            
            switch fetchedFoodDetail.servings.serving.first(where: {
                $0.measurementDescription == initialMeasurementDescription
            }) {
            case let matchingServing?:
                self.selectedServing = matchingServing
            default:
                self.selectedServing = fetchedFoodDetail.servings.serving.first
            }
            
            if !showSaveRemoveButton {
                setAmount(for: selectedServing)
            }
        } catch {
            switch error {
            case let appError as AppError:
                self.appError = appError
            default:
                self.appError = .networkRefresh
            }
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
        let nutrients = nutrientValues.reduce(
            into: [NutrientType: Double]()
        ) {
            result, detail in
            result[detail.type] = detail.value
        }
        let newItem = MealItem(
            foodId: food.searchFoodId,
            foodName: food.searchFoodName,
            portionUnit: selectedServing?.metricServingUnit ?? "",
            nutrients: nutrients,
            measurementDescription:
                selectedServing?.measurementDescription ?? "",
            amount: Double(amount.sanitizedForDouble) ?? 0,
            date: date, mealType: mealType
        )
        
        await MainActor.run {
            mainViewModel.addMealItemMainView(newItem, to: section, for: date)
        }
        
        do {
            try await firestore.addMealItemFirestore(newItem)
        } catch {
            await MainActor.run {
                appError = .network
            }
        }
        
        mainViewModel.triggerFoodAlert()
    }
    
    // MARK: - Update Food Item
    func updateMealItemFoodView(for date: Date) async {
        guard let selectedServing else { return }
        
        let createdAt = didChangeMealType ? Date() : originalCreatedAt
        
        let updatedMealItem = MealItem(
            id: originalMealItemId,
            foodId: food.searchFoodId,
            foodName: food.searchFoodName,
            portionUnit: selectedServing.metricServingUnit,
            nutrients: nutrientValues.reduce(into: [NutrientType: Double]()) {
                result, detail in result[detail.type] = detail.value
            },
            measurementDescription: selectedServing.measurementDescription,
            amount: Double(amount.sanitizedForDouble) ?? 0,
            date: date,
            mealType: mealType,
            createdAt: createdAt
        )
        
        do {
            if originalMealType == mealType {
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
                        for: originalMealType
                    )
                }
                
                if mainViewModel.filteredMealItems(
                    for: originalMealType,
                    on: date
                ).isEmpty {
                    await MainActor.run {
                        mainViewModel.collapseSection(
                            for: originalMealType,
                            to: false
                        )
                    }
                }
                
                await MainActor.run {
                    mainViewModel.addMealItemMainView(
                        updatedMealItem,
                        to: mealType,
                        for: date
                    )
                    mainViewModel.collapseSection(
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
            for: originalMealType
        )
    }
    
    // MARK: - Bookmark Management
    func toggleBookmarkFoodView() async {
        await MainActor.run {
            isBookmarkFilled.toggle()
        }
        await searchViewModel.toggleBookmarkSearchView(for: food)
    }
    
    // MARK: - Serving Selection and Amount Setting
    func updateServing(_ serving: Serving) {
        self.selectedServing = serving
        setAmount(for: serving)
        self.unit = serving.measurementUnit
    }
    
    private func setAmount(for serving: Serving?) {
        guard let serving else {
            self.amount = ""
            return
        }
        
        switch serving.isMetricMeasurement {
        case true: self.amount = "100"
        case false: self.amount = "1"
        }
    }
    
    // MARK: - Serving Description
    func servingDescription(for serving: Serving) -> String {
        var description = serving.measurementDescription
        
        if serving.isMetricMeasurement {
            return description
        }
        
        if description.hasPrefix("serving"),
           let range = description.range(
            of: #"serving\s*\([^)]+\)"#,
            options: .regularExpression
           ) {
            description.replaceSubrange(range, with: "serving")
        }
        
        return "\(description)"
    }
    
    // MARK: - Button States
    var canAddFood: Bool {
        amount.isValidNumericInput()
    }
    
    // MARK: - Nutrient Calculation
    private func calculateSelectedAmountValue() -> Double {
        guard let selectedServing, canAddFood else { return 0 }
        
        let amountValue = Double(amount.sanitizedForDouble) ?? 0
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
        
        switch serving.isMetricMeasurement {
        case true: return amount * 0.01
        case false: return amount
        }
    }
    
    var compactNutrientDetails: [CompactNutrientValue] {
        guard let selectedServing else { return [] }
        return CompactNutrientValueProvider()
            .getCompactNutrientDetails(from: selectedServing)
            .map { detail in
                CompactNutrientValue(
                    type: detail.type,
                    value: detail.value * calculateSelectedAmountValue(),
                    serving: detail.serving
                )
            }
    }
    
    var nutrientValues: [NutrientValue] {
        guard let selectedServing else { return [] }
        
        return NutrientValueProvider()
            .fromServing(selectedServing)
            .map { value in
                NutrientValue(
                    type: value.type,
                    value: value.value * calculateSelectedAmountValue(),
                    isSubValue: value.isSubValue,
                    unit: value.unit
                )
            }
    }
    
    // MARK: - Keyboard
    func normalizeAmount() {
        amount = amount.trimmedLeadingZeros
    }
    
    // MARK: - Focus
    func handleFocusChange(from oldValue: Bool, to newValue: Bool) {
        if newValue {
            originalAmount = amount
            amount = ""
        } else {
            if let newAmount = Double(amount.sanitizedForDouble),
               newAmount > 0 {
                originalAmount = amount
            } else {
                amount = originalAmount
            }
        }
    }
    
    // MARK: - UI Helper
    var viewState: FoodViewState {
        if let error = appError {
            return .error(error)
        } else if isLoading {
            return .loading
        } else {
            return .loaded
        }
    }
}

enum MeasurementUnit: String, CaseIterable, Identifiable {
    case servings = "Servings"
    case grams = "Grams"
    
    var id: String { self.rawValue }
}

enum FoodViewState {
    case loading
    case error(AppError)
    case loaded
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
