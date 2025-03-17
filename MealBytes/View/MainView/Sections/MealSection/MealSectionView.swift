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
            calories: viewModel.totalNutrient(.calories, for: mealItems),
            fats: viewModel.totalNutrient(.fat, for: mealItems),
            proteins: viewModel.totalNutrient(.protein, for: mealItems),
            carbohydrates: viewModel.totalNutrient(.carbohydrates, for: mealItems),
            foodItems: mealItems,
            mainViewModel: viewModel
        )
    }
}

#Preview {
    MainView()
}
