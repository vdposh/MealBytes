//
//  MealSectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
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
            fat: mainViewModel.totalNutrient(.fat, for: mealItems),
            protein: mainViewModel.totalNutrient(.protein, for: mealItems),
            carbohydrate: mainViewModel.totalNutrient(.carbohydrate,
                                                       for: mealItems),
            foodItems: mealItems
        )
        
        return MealSection(
            model: model,
            mainViewModel: mainViewModel
        )
    }
}
