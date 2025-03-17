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
    @Published var mealItems: [MealType: [MealItem]] = {
        var items = [MealType: [MealItem]]()
        MealType.allCases.forEach { items[$0] = [] }
        return items
    }()
    
    @Published var nutrientSummaries: [NutrientType: Double] = NutrientType.allCases
        .reduce(into: [NutrientType: Double]()) { $0[$1] = 0.0 }

    // MARK: - Calculate Totals for Nutrients
    func totalNutrient(_ nutrient: NutrientType, for mealItems: [MealItem]) -> Double {
        mealItems.reduce(0) { $0 + $1.nutrients.value(for: nutrient) }
    }

    // MARK: - Add Food Item
    func addFoodItem(_ item: MealItem, to mealType: MealType) {
        mealItems[mealType]?.append(item)
        recalculateNutrients()
    }

    // MARK: - Recalculate Nutrients
    private func recalculateNutrients() {
        nutrientSummaries = NutrientType.allCases.reduce(
            into: [NutrientType: Double]()) { result, nutrient in
                result[nutrient] = mealItems.values.flatMap { $0 }
                    .reduce(0) { $0 + ($1.nutrients[nutrient] ?? 0.0) }
            }
    }
}


#Preview {
    MainView()
}
