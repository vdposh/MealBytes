//
//  FoodViewModel.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Combine
import FirebaseCore

final class FoodViewModel: ObservableObject {
    @Published var selectedServing: Serving?
    @Published var amount: String = ""
    @Published var originalAmount: String = ""
    @Published var errorMessage: AppError?
    @Published var unit: MeasurementUnit = .grams
    @Published var showActionSheet = false
    @Published var isLoading = true
    @Published var isError = false
    @Published var isBookmarkFilled = false
    @Published var shouldUseOriginalAmount: Bool = false
    @Published var foodDetail: FoodDetail? {
        didSet {
            self.selectedServing = nil
        }
    }
    
    private let initialMeasurementDescription: String
    private let showSaveRemoveButton: Bool
    let food: Food
    let mealType: MealType
    let originalMealItemId: UUID
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    let searchViewModel: SearchViewModel
    let mainViewModel: MainViewModel
    
    init(food: Food,
         mealType: MealType,
         searchViewModel: SearchViewModel,
         mainViewModel: MainViewModel,
         initialAmount: String = "",
         initialMeasurementDescription: String = "",
         showSaveRemoveButton: Bool = false,
         originalMealItemId: UUID? = nil) {
        let roundedAmount = Formatter().formattedValue(
            Double(initialAmount),
            unit: .empty,
            alwaysRoundUp: false
        )
        
        self.food = food
        self.mealType = mealType
        self.searchViewModel = searchViewModel
        self.mainViewModel = mainViewModel
        self.isBookmarkFilled = searchViewModel.isBookmarkedSearchView(food)
        self.amount = roundedAmount
        self.initialMeasurementDescription = initialMeasurementDescription
        self.showSaveRemoveButton = showSaveRemoveButton
        self.originalMealItemId = originalMealItemId ?? UUID()
    }
    
    // MARK: - Fetch Food Details
    @MainActor
    func fetchFoodDetails() async {
        isLoading = true
        do {
            let fetchedFoodDetail = try await networkManager
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
                self.errorMessage = appError
            default:
                self.errorMessage = .network
            }
            isError = true
        }
        isLoading = false
    }
    
    // MARK: - Add a food item
    func addMealItemFoodView(in section: MealType, for date: Date) {
        let nutrients = nutrientDetails.reduce(into: [NutrientType: Double]()) {
            result, detail in
            result[detail.type] = detail.value
        }
        let newItem = MealItem(
            foodId: food.searchFoodId,
            foodName: food.searchFoodName,
            portionUnit: nutrientDetails.first(where: {
                $0.type == .servingSize })?.serving.metricServingUnit ?? "",
            nutrients: nutrients,
            measurementDescription:
                selectedServing?.measurementDescription ?? "",
            amount: Double(amount.sanitizedForDouble) ?? 0,
            date: date, mealType: mealType
        )
        mainViewModel.addMealItemMainView(newItem, to: section, for: date)
        Task {
            try? await firestore.addMealItemFirestore(newItem)
        }
    }
    
    // MARK: - Resave food
    func updateMealItemFoodView(for date: Date) async {
        guard let selectedServing else { return }
        
        let updatedMealItem = MealItem(
            id: originalMealItemId,
            foodId: food.searchFoodId,
            foodName: food.searchFoodName,
            portionUnit: selectedServing.metricServingUnit,
            nutrients: nutrientDetails.reduce(into: [NutrientType: Double]()) {
                result, detail in
                result[detail.type] = detail.value
            },
            measurementDescription: selectedServing.measurementDescription,
            amount: Double(amount.sanitizedForDouble) ?? 0,
            date: date, mealType: mealType
        )
        
        Task {
            mainViewModel.updateMealItemMainView(updatedMealItem,
                                                 for: mealType,
                                                 on: date)
            try? await mainViewModel
                .firestore.updateMealItemFirestore(updatedMealItem)
        }
    }
    
    // MARK: - Delete food
    func deleteMealItemFoodView() async {
        mainViewModel.deleteMealItemMainView(with: originalMealItemId,
                                             for: mealType)
    }
    
    // MARK: - Bookmark Management
    func toggleBookmarkFoodView() {
        isBookmarkFilled.toggle()
        searchViewModel.toggleBookmarkSearchView(for: food)
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
        case true:
            self.amount = "100"
        case false:
            self.amount = "1"
        }
    }
    
    func handleFocusChange(from oldValue: Bool, to newValue: Bool) {
        if newValue {
            originalAmount = amount
            amount = ""
        } else {
            if let newAmount = Double(amount), newAmount > 0 {
                originalAmount = amount
            } else {
                amount = originalAmount
            }
        }
    }
    
    // MARK: - Serving Description
    func servingDescription(for serving: Serving) -> String {
        let description = serving.measurementDescription
        let metricAmount = Int(serving.metricServingAmount)
        let metricUnit = serving.metricServingUnit
        
        switch serving.isMetricMeasurement {
        case true:
            return description
        case false where description.contains("serving (\(metricAmount)g"):
            return description
        default:
            return "\(description) (\(metricAmount)\(metricUnit))"
        }
    }
    
    var servingDescription: String {
        guard let selectedServing else {
            return "Select Serving"
        }
        return servingDescription(for: selectedServing)
    }
    
    // MARK: - Button States
    var canAddFood: Bool {
        let amountValue = Double(amount.sanitizedForDouble) ?? 0
        return amountValue > 0
    }
    
    // MARK: - Nutrient Calculation
    private func calculateSelectedAmountValue() -> Double {
        guard let selectedServing else { return 1 }
        let amountValue = Double(amount.sanitizedForDouble) ?? 0
        return calculateBaseAmountValue(amountValue,
                                        serving: selectedServing)
    }
    
    private func calculateBaseAmountValue(_ amount: Double,
                                          serving: Serving) -> Double {
        if amount.isZero {
            return 0
        }
        
        switch serving.isMetricMeasurement {
        case true:
            return amount * 0.01
        case false:
            return amount
        }
    }
    
    var compactNutrientDetails: [CompactNutrientDetail] {
        guard let selectedServing else { return [] }
        return CompactNutrientDetailProvider()
            .getCompactNutrientDetails(from: selectedServing)
            .map { detail in
                CompactNutrientDetail(
                    type: detail.type,
                    value: detail.value * calculateSelectedAmountValue(),
                    serving: detail.serving
                )
            }
    }
    
    var nutrientDetails: [NutrientDetail] {
        guard let selectedServing else { return [] }
        return NutrientDetailProvider()
            .getNutrientDetails(from: selectedServing)
            .map { detail in
                NutrientDetail(
                    type: detail.type,
                    value: detail.value * calculateSelectedAmountValue(),
                    serving: selectedServing,
                    isSubValue: detail.isSubValue
                )
            }
    }
}

enum MeasurementUnit: String, CaseIterable, Identifiable {
    case servings = "Servings"
    case grams = "Grams"
    
    var id: String { self.rawValue }
}
