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
    @Published var errorMessage: IdentifiableString?
    @Published var showActionSheet = false
    
    let food: Food
    @Published var unit: MeasurementUnit = .grams
    
    private let networkManager: NetworkManagerProtocol
    
    init(food: Food,
         networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.food = food
        self.networkManager = networkManager
    }
    
    @MainActor
    func fetchFoodDetails() {
        Task {
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
                self.errorMessage = IdentifiableString(
                    value: error.localizedDescription)
            }
        }
    }
    
    //если выбрана порция - ставится 1, если выбраны г или мг - 100
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
    //для верстки
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
    //размер порции для sheet
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
    //для кнопки: если в decimalPad 0 или 0,0, кнопка неактивна
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
            food_name: "Oats",
            food_description: ""
        )
    )
}
