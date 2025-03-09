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
        do {
            let fetchedFoodDetail = try await networkManager
                .fetchFoodDetails(foodID: food.searchFoodId)
            self.foodDetail = fetchedFoodDetail
        } catch {
            switch error {
            case let appError as AppError:
                self.errorMessage = appError
            default:
                self.errorMessage = .networkError
            }
        }
    }
    
    // MARK: - Serving Selection and Amount Setting
    func updateServing(_ serving: Serving) {
        self.selectedServing = serving
        setAmount(for: serving)
        self.unit = MeasurementType
            .grams.fromDescription(serving.measurementDescription) == .grams ||
        MeasurementType
            .milliliters.fromDescription(serving.measurementDescription) ==
            .milliliters ? .grams : .servings
    }
    
    func setAmount(for serving: Serving?) {
        if let serving {
            switch MeasurementType
                .grams.fromDescription(serving.measurementDescription) {
            case .grams, .milliliters:
                self.amount = "100"
            default:
                self.amount = "1"
            }
        }
    }
    
    // MARK: - Serving Description
    func servingDescription(for serving: Serving) -> String {
        let description = serving.measurementDescription
        let metricAmount = Int(serving.metricServingAmount)
        let metricUnit = serving.metricServingUnit
        
        if MeasurementType.grams.fromDescription(description) == .grams ||
            MeasurementType.milliliters.fromDescription(description) ==
            .milliliters ||  description.contains("serving (\(metricAmount)g") {
            return description
        }
        
        return "\(description) (\(metricAmount)\(metricUnit))"
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
        if amount == 0 {
            return 0
        }
        return MeasurementType
            .grams.fromDescription(measurementDescription) == .grams ||
        MeasurementType.milliliters.fromDescription(measurementDescription) ==
            .milliliters ? amount * 0.01 : amount
    }
    
    var nutrientBlocks: [CompactNutrientDetail] {
        guard let selectedServing else { return [] }
        return CompactNutrientDetailProvider()
            .getCompactNutrientDetails(from: selectedServing)
            .map { detail in
                CompactNutrientDetail(
                    title: detail.title,
                    value: detail.value * calculateSelectedAmountValue(),
                    unit: detail.unit)
            }
    }
    
    var nutrientDetails: [NutrientDetail] {
        guard let selectedServing else { return [] }
        return NutrientDetailProvider()
            .getNutrientDetails(from: selectedServing)
            .map { detail in
                NutrientDetail(
                    title: detail.type.title,
                    value: detail.value * calculateSelectedAmountValue(),
                    unit: detail.type.unit,
                    isSubValue: detail.isSubValue)
            }
    }
}

enum MeasurementType: String {
    case grams = "g"
    case milliliters = "ml"
    case servings
    
    func fromDescription(_ description: String) -> MeasurementType {
        switch description {
        case "g": .grams
        case "ml": .milliliters
        default: .servings
        }
    }
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
