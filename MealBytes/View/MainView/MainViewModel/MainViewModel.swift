//
//  MainViewModel.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI
import Combine

final class MainViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var foodItems: [MealItem] = []
    
    @Published var nutrientSummaries: [NutrientType: Double] = NutrientType.allCases
        .reduce(into: [NutrientType: Double]()) { $0[$1] = 0.0 }

    // MARK: - Add Food Item
    func addFoodItem(_ item: MealItem) {
        // Добавление элемента еды в список
        foodItems.append(item)
        recalculateNutrients()
    }

    // MARK: - Recalculate Nutrients
    private func recalculateNutrients() {
        // Пересчёт сумм нутриентов
        nutrientSummaries = NutrientType.allCases.reduce(into: [NutrientType: Double]()) { result, nutrient in
            result[nutrient] = foodItems.reduce(0) { $0 + ($1.nutrients[nutrient] ?? 0.0) }
        }
    }
}

#Preview {
    MainView()
}
