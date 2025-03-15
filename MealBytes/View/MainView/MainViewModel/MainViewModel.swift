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
    
    // MARK: - Add Food Item
    func addFoodItem(_ item: MealItem) {
        foodItems.append(item)
    }

    // MARK: - Calculate Nutrients
    func calculateCalories() -> Double {
        foodItems.reduce(0) { $0 + $1.calories }
    }
    
    func calculateFats() -> Double {
        foodItems.reduce(0) { $0 + $1.fats }
    }
    
    func calculateProteins() -> Double {
        foodItems.reduce(0) { $0 + $1.proteins }
    }
    
    func calculateCarbohydrates() -> Double {
        foodItems.reduce(0) { $0 + $1.carbohydrates }
    }
}

#Preview {
    MainView()
}
