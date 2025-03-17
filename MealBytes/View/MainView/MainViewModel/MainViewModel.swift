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
    @Published var mealItems: [MealType: [MealItem]]
    @Published var nutrientSummaries: [NutrientType: Double]
    @Published var isExpanded: Bool = false
    let searchViewModel: SearchViewModel
    let formatter = Formatter()
    
    init(searchViewModel: SearchViewModel = SearchViewModel()) {
        var items = [MealType: [MealItem]]()
        MealType.allCases.forEach { items[$0] = [] }
        self.mealItems = items
        
        var summaries = [NutrientType: Double]()
        NutrientType.allCases.forEach { summaries[$0] = 0.0 }
        self.nutrientSummaries = summaries
        
        self.searchViewModel = searchViewModel
    }
    
    // MARK: - Calculate Date Offset
    func date(for offset: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: offset, to: Date()) ?? Date()
    }
    
    // MARK: - Filtered Nutrients
    var filteredNutrients: [DetailedNutrient] {
        let allNutrients = DetailedNutrientProvider()
            .getDetailedNutrients(from: nutrientSummaries)
        
        switch isExpanded {
        case true:
            return allNutrients
        case false:
            return allNutrients.filter {
                [.calories, .fat, .protein, .carbohydrates].contains($0.type)
            }
        }
    }
    
    // MARK: - Value for Nutrient Type
    func value(for type: NutrientType) -> Double {
        nutrientSummaries[type] ?? 0.0
    }
    
    // MARK: - Format Serving Size
    func formattedServingSize(for mealItem: MealItem) -> String {
        return formatter.formattedValue(mealItem.nutrients[.servingSize] ?? 0.0, unit: .empty)
    }
    
    // MARK: - Format Calories
    func formattedCalories(_ calories: Double) -> String {
        return formatter.formattedValue(calories, unit: .empty, alwaysRoundUp: true)
    }
    
    // MARK: - Format Value
    func formattedValue(_ value: Double, unit: Formatter.Unit, alwaysRoundUp: Bool) -> String {
        return formatter.formattedValue(value, unit: unit, alwaysRoundUp: alwaysRoundUp)
    }
    
    // MARK: - Calculate Totals for Nutrients
    func totalNutrient(_ nutrient: NutrientType, for mealItems: [MealItem]) -> Double {
        mealItems.reduce(0) { $0 + ($1.nutrients[nutrient] ?? 0.0) }
    }
    
    // MARK: - Add Food Item
    func addFoodItem(_ item: MealItem, to mealType: MealType) {
        mealItems[mealType]?.append(item)
        recalculateNutrients()
    }
    
    // MARK: - Recalculate Nutrients
    func recalculateNutrients() {
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
