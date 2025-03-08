//
//  FoodViewModel.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Combine

final class FoodViewModel: ObservableObject {
    @Published var foodDetail: FoodDetail?
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
                .getFoodDetails(foodID: food.food_id)
            self.foodDetail = fetchedFoodDetail
            if self.foodDetail?.servings.serving.isEmpty ?? true {
                self.selectedServing = nil
            } else {
                self.selectedServing = self.foodDetail?
                    .servings.serving.first
                setAmount(for: self.selectedServing)
            }
        } catch {
            if let appError = error as? AppErrorType {
                self.errorMessage = AppError(error: appError)
            } else {
                self.errorMessage = AppError(title: "Unknown Error",
                                             message: error.localizedDescription)
            }
        }
    }

    // MARK: - Serving Selection and Amount Setting
    func updateServing(_ serving: Serving) {
        self.selectedServing = serving
        setAmount(for: serving)
        self.unit = (serving.measurementDescription == "g" ||
                     serving.measurementDescription == "ml") ?
            .grams : .servings
    }
    
    func setAmount(for serving: Serving?) {
        if let serving {
            if serving.measurementDescription == "g" ||
                serving.measurementDescription == "ml" {
                self.amount = "100"
            } else {
                self.amount = "1"
            }
        }
    }
    
    // MARK: - Nutrient Information Views
    func nutrientBlockView(title: String,
                           value: Double,
                           unit: String,
                           amountValue: Double) -> some View {
        NutrientBlockView(
            title: title,
            value: (value) * amountValue,
            unit: unit
        )
    }

    func nutrientDetailRow(title: String,
                           value: Double,
                           unit: String,
                           amountValue: Double,
                           isSubValue: Bool = false) -> some View {
        NutrientDetailRow(
            title: title,
            value: (value) * amountValue,
            unit: unit,
            isSubValue: isSubValue
        )
    }
    
    func calculateAmountValue() -> Double {
        guard let selectedServing = selectedServing else { return 1 }
        let amountValue = Double(amount.replacingOccurrences(of: ",",
                                                             with: ".")) ?? 0
        return Formatter.calculateAmountValue(
            String(amountValue),
            measurementDescription: selectedServing.measurementDescription)
    }
    
    // MARK: - Serving Description
    func servingDescription(for serving: Serving) -> String {
        let description = serving.measurementDescription
        let metricAmount = Int(serving.metricServingAmount)
        let metricUnit = serving.metricServingUnit
        
        if description == "g" || description == "ml" ||
            description.contains("serving (\(metricAmount)g") {
            return description
        }
        
        let metricInfo = " (\(metricAmount)\(metricUnit))"
        return description + metricInfo
    }
    
    var servingDescription: String {
        guard let serving = selectedServing else {
            return "Select Serving"
        }
        return servingDescription(for: serving)
    }
    
    // MARK: - Button States
    func isAddToDiaryButtonEnabled() -> Bool {
        let amountValue = Double(amount.replacingOccurrences(of: ",",
                                                             with: ".")) ?? 0
        return amountValue > 0
    }
}

#Preview {
    FoodView(
        food: Food(
            food_id: "39715",
            food_name: "Oats, 123",
            food_description: ""
        )
    )
}
