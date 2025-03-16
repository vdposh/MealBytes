//
//  MealSection.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

// MARK: - Displays a meal section by incorporating its header view, macronutrient summary, and food items
struct MealSection: View {
    let title: String
    let iconName: String
    let color: Color
    let calories: Double
    let fats: Double
    let proteins: Double
    let carbohydrates: Double
    let foodItems: [MealItem]
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        MealHeaderView(
            title: title,
            iconName: iconName,
            color: color,
            calories: calories,
            fats: fats,
            proteins: proteins,
            carbohydrates: carbohydrates,
            foodItems: foodItems,
            mainViewModel: mainViewModel
        )
    }
}
