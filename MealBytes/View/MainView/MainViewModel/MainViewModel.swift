//
//  MainViewModel.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI
import Combine
import FirebaseCore
import FirebaseFirestore

final class MainViewModel: ObservableObject {
    @Published var date = Date()
    @Published var mealItems: [MealType: [MealItem]]
    @Published var nutrientSummaries: [NutrientType: Double]
    @Published var expandedSections: [MealType: Bool] = [:]
    @Published var isExpanded: Bool = false
    let calendar = Calendar.current
    let searchViewModel: SearchViewModel
    let firestoreService: FirestoreManagerProtocol
    let formatter = Formatter()
    
    init(searchViewModel: SearchViewModel = SearchViewModel(),
         firestoreService: FirestoreManagerProtocol = FirestoreManager()) {
        var items = [MealType: [MealItem]]()
        MealType.allCases.forEach { items[$0] = [] }
        self.mealItems = items
        var summaries = [NutrientType: Double]()
        NutrientType.allCases.forEach { summaries[$0] = 0.0 }
        self.nutrientSummaries = summaries
        self.searchViewModel = searchViewModel
        self.firestoreService = firestoreService
        var sections = [MealType: Bool]()
        MealType.allCases.forEach { sections[$0] = false }
        self.expandedSections = sections
    }
    
    // MARK: - Load Meal Item
    func loadMealItemsMainView() async {
        let mealItems = try? await firestoreService.loadMealItemsFirebase()
        await MainActor.run {
            self.mealItems = Dictionary(
                grouping: mealItems ?? [],
                by: { $0.mealType }
            )
            self.recalculateNutrients(for: self.date)
        }
    }
    
    // MARK: - Add Food Item
    func addMealItemMainView(_ item: MealItem, to mealType: MealType, for date: Date) {
        mealItems[mealType, default: []].append(item)
        expandedSections[mealType] = true
        recalculateNutrients(for: date)
    }
    
    // MARK: - Update Meal Item
    func updateMealItemMainView(_ updatedItem: MealItem,
                        for mealType: MealType,
                        on date: Date) {
        guard var items = mealItems[mealType] else { return }
        
        if let index = items.firstIndex(where: {
            $0.id == updatedItem.id &&
            calendar.isDate($0.date, inSameDayAs: date)
        }) {
            items[index] = updatedItem
        }
        
        mealItems[mealType] = items
        recalculateNutrients(for: date)
    }
    
    // MARK: - Delete Meal Item
    func deleteMealItemMainView(with id: UUID, for mealType: MealType) {
        guard var items = mealItems[mealType] else { return }
        items.removeAll { $0.id == id }
        mealItems[mealType] = items
        recalculateNutrients(for: date)
        if mealItems[mealType]?.isEmpty == true {
            expandedSections[mealType] = false
        }
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
    ) -> [String: String] {
        func format(_ value: Double?) -> String {
            formatter.formattedValue(value ?? 0.0, unit: .empty)
        }
        
        switch source {
        case .summaries(let summaries):
            return [
                "Fat": format(summaries[.fat]),
                "Carbs": format(summaries[.carbohydrates]),
                "Protein": format(summaries[.protein])
            ]
        case .details(let fats, let carbs, let proteins):
            return [
                "F": format(fats),
                "C": format(carbs),
                "P": format(proteins)
            ]
        }
    }
    
    // MARK: - Color for Calendar
    func color(for element: DisplayElement,
               date: Date? = nil,
               isSelected: Bool = false,
               isToday: Bool = false,
               forBackground: Bool = false) -> Color {
        switch forBackground {
        case true:
            return isSelected ? .customGreen.opacity(0.2) : .clear
        case false:
            if isSelected {
                return .customGreen
            }
            if isToday {
                return .customGreen
            }
            if let date {
                if !calendar.isDate(date, equalTo: self.date,
                                    toGranularity: .month) {
                    return .secondary
                }
            }
            switch element {
            case .day:
                return .primary
            case .weekday:
                return .secondary
            }
        }
    }
    
    // MARK: - Calculate Date Offset
    func date(for offset: Int) -> Date {
        Calendar.current.date(byAdding: .day,
                              value: offset,
                              to: Date()) ?? Date()
    }
    
    // MARK: - Formatted year for Calendar
    func formattedYearDisplay() -> String {
        switch calendar.isDate(date,
                               equalTo: Date(),
                               toGranularity: .year) {
        case true:
            date.formatted(.dateTime.month(.wide).day().weekday(.wide))
        case false:
            date.formatted(.dateTime.month(.wide).day().weekday(.wide).year())
        }
    }
    
    // MARK: - Recalculate Nutrients
    func recalculateNutrients(for date: Date) {
        nutrientSummaries = NutrientType.allCases
            .reduce(into: [NutrientType: Double]()) {
                result, nutrient in
                let relevantItems = mealItems.values.flatMap { $0 }
                    .filter { calendar.isDate($0.date, inSameDayAs: date) }
                
                result[nutrient] = relevantItems.reduce(0) {
                    $0 + ($1.nutrients[nutrient] ?? 0.0) }
            }
    }
    
    func summariesForCaloriesSection() -> [NutrientType: Double] {
        let relevantItems = mealItems.values.flatMap { $0 }
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
        
        return NutrientType.allCases.reduce(into: [NutrientType: Double]()) {
            result, nutrient in
            result[nutrient] = relevantItems.reduce(0) {
                $0 + ($1.nutrients[nutrient] ?? 0.0) }
        }
    }
}

enum NutrientSource {
    case summaries([NutrientType: Double])
    case details(fats: Double, carbs: Double, proteins: Double)
}

enum DisplayElement {
    case day
    case weekday
}

#Preview {
    NavigationStack {
        MainView(mainViewModel: MainViewModel())
    }
    .accentColor(.customGreen)
}
