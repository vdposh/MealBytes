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
    
    private let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    @MainActor
    func fetchFoodDetails(foodID: String) {
        Task {
            do {
                let fetchedFoodDetail = try await networkManager
                    .getFoodDetails(foodID: foodID)
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
            if serving.measurement_description == "g" ||
                serving.measurement_description == "ml" {
                self.amount = "100"
            } else {
                self.amount = "1"
            }
        }
    }
    
    func calculateAmountValue() -> Double {
        guard let selectedServing = selectedServing else { return 1 }
        let amountValue = Double(amount.replacingOccurrences(of: ",",
                                                             with: ".")) ?? 0
        return Formatter.calculateAmountValue(String(amountValue),
                                              measurementDescription:
            selectedServing.measurement_description ?? "")
    }
    //размер порции для sheet
    func servingDescription(for serving: Serving) -> String {
        let description = serving.measurement_description ?? ""
        let metricAmount = Int(serving.metric_serving_amount ?? 0)
        let metricUnit = serving.metric_serving_unit ?? ""
        
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
