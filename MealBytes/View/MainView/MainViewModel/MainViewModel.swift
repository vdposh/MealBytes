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
    @Published var expandedSections: [MealType: Bool] = [:]
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
        var sections = [MealType: Bool]()
        MealType.allCases.forEach { sections[$0] = false }
        self.expandedSections = sections
    }
    
    // MARK: - Calculate Date Offset
    func date(for offset: Int) -> Date {
        Calendar.current.date(byAdding: .day,
                              value: offset,
                              to: Date()) ?? Date()
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
        return formatter.formattedValue(mealItem.nutrients[.servingSize] ?? 0.0,
                                        unit: .empty)
    }
    
    // MARK: - Format Calories
    func formattedCalories(_ calories: Double) -> String {
        return formatter.formattedValue(calories,
                                        unit: .empty,
                                        alwaysRoundUp: true)
    }
    
    // MARK: - Format Value
    func formattedValue(_ value: Double,
                        unit: Formatter.Unit,
                        alwaysRoundUp: Bool) -> String {
        return formatter.formattedValue(value,
                                        unit: unit,
                                        alwaysRoundUp: alwaysRoundUp)
    }
    
    // MARK: - Calculate Totals for Nutrients
    func totalNutrient(_ nutrient: NutrientType,
                       for mealItems: [MealItem]) -> Double {
        mealItems.reduce(0) { $0 + ($1.nutrients[nutrient] ?? 0.0) }
    }
    
    // MARK: - Formatting nutrients
    func formattedNutrients(
        source: NutrientSource
    ) -> (fat: String, carb: String, protein: String) {
        func format(_ value: Double?) -> String {
            formatter.formattedValue(value ?? 0.0, unit: .empty)
        }
        
        switch source {
        case .summaries(let summaries):
            return (
                fat: format(summaries[.fat]),
                carb: format(summaries[.carbohydrates]),
                protein: format(summaries[.protein])
            )
        case .details(let fats, let carbs, let proteins):
            return (
                fat: format(fats),
                carb: format(carbs),
                protein: format(proteins)
            )
        }
    }
    
    // MARK: - Recalculate Nutrients
    func recalculateNutrients() {
        nutrientSummaries = NutrientType.allCases.reduce(
            into: [NutrientType: Double]()) { result, nutrient in
                result[nutrient] = mealItems.values.flatMap { $0 }
                    .reduce(0) { $0 + ($1.nutrients[nutrient] ?? 0.0) }
            }
    }
    
    // MARK: - Add Food Item
    func addFoodItem(_ item: MealItem, to mealType: MealType) {
        mealItems[mealType]?.append(item)
        expandedSections[mealType] = true
        recalculateNutrients()
    }
    
    // MARK: - Update Meal Item
    func updateMealItem(_ updatedItem: MealItem, for mealType: MealType) {
        guard var items = mealItems[mealType] else { return }
        
        if let index = items.firstIndex(where: { $0.id == updatedItem.id }) {
            items[index] = updatedItem
        }
        
        mealItems[mealType] = items
        recalculateNutrients()
    }
    
    // MARK: - Delete Meal Item
    func deleteMealItem(with id: UUID, for mealType: MealType) {
        guard var items = mealItems[mealType] else { return }
        items.removeAll { $0.id == id }
        mealItems[mealType] = items
        recalculateNutrients()
        if mealItems[mealType]?.isEmpty == true {
            expandedSections[mealType] = false
        }
    }
}

enum NutrientSource {
    case summaries([NutrientType: Double])
    case details(fats: Double, carbs: Double, proteins: Double)
}

#Preview {
    MainView(mainViewModel: MainViewModel())
}
