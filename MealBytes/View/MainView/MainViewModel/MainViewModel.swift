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
    @Published var calories: Int = 0
    @Published var fats: Int = 0
    @Published var proteins: Int = 0
    @Published var carbohydrates: Int = 0
    @Published var isDatePickerPresented = false
    @Published var meals: [MealType: [Food]] = [:]
    
    init() {
        for meal in MealType.allCases {
            meals[meal] = []
        }
    }
    
    func addFood(_ food: Food, to meal: MealType) {
        meals[meal]?.append(food)
        updateNutrientValues()
    }
    
    func updateNutrientValues() {
        // Обновляем значения калорий, жиров, белков и углеводов
    }
}

enum MealType: String, CaseIterable, Identifiable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case other = "Other"
    
    var id: String { self.rawValue }
}

#Preview {
    MainView()
}
