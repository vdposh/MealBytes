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
    let mainViewModel: MainViewModel
    
    var body: some View {
        let model = MealSectionModel(
            mealType: mealType,
            title: mealType.rawValue,
            iconName: mealType.iconName,
            color: mealType.color,
            calories: mainViewModel.totalNutrient(.calories, for: mealItems),
            fats: mainViewModel.totalNutrient(.fat, for: mealItems),
            proteins: mainViewModel.totalNutrient(.protein, for: mealItems),
            carbohydrates: mainViewModel.totalNutrient(.carbohydrates, for: mealItems),
            foodItems: mealItems
        )
        
        return MealSection(
            model: model,
            mainViewModel: mainViewModel
        )
    }
}

#Preview {
    MainView(mainViewModel: MainViewModel())
}
