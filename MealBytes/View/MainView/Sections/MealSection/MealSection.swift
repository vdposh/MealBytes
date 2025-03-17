//
//  MealSection.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct MealSection: View {
    let mealType: MealType
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
            mealType: mealType,
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

#Preview {
    MainView()
}
