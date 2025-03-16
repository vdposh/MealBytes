//
//  MealSectionView.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct MealSectionView: View {
    let mealType: MealType
    let mealItems: [MealItem]
    let viewModel: MainViewModel
    
    var body: some View {
        MealSection(
            mealType: mealType,
            title: mealType.rawValue,
            iconName: mealType.iconName,
            color: mealType.color,
            calories: mealItems.reduce(0) { $0 + ($1.nutrients[.calories] ?? 0.0) },
            fats: mealItems.reduce(0) { $0 + ($1.nutrients[.fat] ?? 0.0) },
            proteins: mealItems.reduce(0) { $0 + ($1.nutrients[.protein] ?? 0.0) },
            carbohydrates: mealItems.reduce(0) { $0 + ($1.nutrients[.carbohydrates] ?? 0.0) },
            foodItems: mealItems,
            mainViewModel: viewModel
        )
    }
}
