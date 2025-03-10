//
//  FoodViewModel.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Combine

final class FoodViewModel: ObservableObject {
    @Published var foodDetail: FoodDetail? {
        didSet {
            self.selectedServing = self.foodDetail?.servings.serving.first
            setAmount(for: self.selectedServing)
        }
    }
    @Published var selectedServing: Serving?
    @Published var amount: String = ""
    @Published var errorMessage: AppError?
    @Published var showActionSheet = false
    @Published var unit: MeasurementUnit = .grams
    @Published var isLoading = true
    @Published var isError = false
    
    let food: Food
    
    private let networkManager: NetworkManagerProtocol
    
    init(food: Food,
         networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.food = food
        self.networkManager = networkManager
    }
    
    // MARK: - Fetch Food Details
    @MainActor
    func fetchFoodDetails() async {
        isLoading = true
        do {
            let fetchedFoodDetail = try await networkManager
                .fetchFoodDetails(foodId: food.searchFoodId)
            self.foodDetail = fetchedFoodDetail
        } catch {
            switch error {
            case let appError as AppError:
                self.errorMessage = appError
            default:
                self.errorMessage = .networkError
            }
            isError = true
        }
        isLoading = false
    }
    
    // MARK: - Serving Selection and Amount Setting
    func updateServing(_ serving: Serving) {
        self.selectedServing = serving
        setAmount(for: serving)
        self.unit = serving.measurementUnit
    }
    
    func setAmount(for serving: Serving?) {
        guard let serving else {
            self.amount = ""
            return
        }
        
        self.amount = serving.isGramsOrMilliliters ? "100" : "1"
    }
    
    // MARK: - Serving Description
    func servingDescription(for serving: Serving) -> String {
        let description = serving.measurementDescription
        let metricAmount = Int(serving.metricServingAmount)
        let metricUnit = serving.metricServingUnit

        switch description {
        case MeasurementType.grams.rawValue,
            MeasurementType.milliliters.rawValue:
            return description
        case let desc where desc.contains("serving (\(metricAmount)g"):
            return description
        default:
            return "\(description) (\(metricAmount)\(metricUnit))"
        }
    }

    var servingDescription: String {
        guard let serving = selectedServing else {
            return "Select Serving"
        }
        return servingDescription(for: serving)
    }
    
    // MARK: - Button States
    func isAddButtonEnabled() -> Bool {
        let amountValue = Double(amount.replacingOccurrences(of: ",",
                                                             with: ".")) ?? 0
        return amountValue > 0
    }
    
    // MARK: - Nutrient Calculation
    func calculateSelectedAmountValue() -> Double {
        guard let selectedServing else { return 1 }
        let amountValue = Double(amount.replacingOccurrences(of: ",",
                                                             with: ".")) ?? 0
        return calculateBaseAmountValue(
            amountValue,
            measurementDescription: selectedServing.measurementDescription)
    }
    
    func calculateBaseAmountValue(_ amount: Double,
                                  measurementDescription: String) -> Double {
        if amount.isZero {
            return 0
        }
        
        switch measurementDescription {
        case MeasurementType.grams.rawValue,
            MeasurementType.milliliters.rawValue:
            return amount * 0.01
        default:
            return amount
        }
    }
    
    var compactNutrientDetails: [CompactNutrientDetail] {
        guard let selectedServing else { return [] }
        return CompactNutrientDetailProvider()
            .getCompactNutrientDetails(from: selectedServing)
            .map { detail in
                CompactNutrientDetail(
                    id: detail.id,
                    type: detail.type,
                    value: detail.value * calculateSelectedAmountValue(),
                    unit: detail.unit
                )
            }
    }
    
    var nutrientDetails: [NutrientDetail] {
        guard let selectedServing else { return [] }
        return NutrientDetailProvider()
            .getNutrientDetails(from: selectedServing)
            .map { detail in
                NutrientDetail(
                    id: detail.id,
                    type: detail.type,
                    value: detail.value * calculateSelectedAmountValue(),
                    unit: detail.type.unit,
                    isSubValue: detail.isSubValue
                )
            }
    }
}

enum MeasurementType: String {
    case grams = "g"
    case milliliters = "ml"
    case servings
}

enum MeasurementUnit: String, CaseIterable, Identifiable {
    case servings = "Servings"
    case grams = "Grams"
    
    var id: String { self.rawValue }
}

#Preview {
    FoodView(
        food: Food(
            searchFoodId: "39715",
            searchFoodName: "Oats, 123",
            searchFoodDescription: ""
        )
    )
}
