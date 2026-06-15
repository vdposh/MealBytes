//
//  MealSectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct MealSectionView: View {
    @Binding var selectedMealItemForMove: MealItem?
    
    let mealType: MealType
    let mealItems: [MealItem]
    let mainViewModel: MainViewModel
    
    var body: some View {
        let nutrients = mainViewModel.totalNutrients(for: mealType)
        
        let model = MealSectionModel(
            mealType: mealType,
            title: mealType.rawValue,
            calories: Double(mainViewModel.totalCalories(for: mealType)),
            fat: nutrients.fat,
            protein: nutrients.protein,
            carbohydrate: nutrients.carbs,
            foodItems: mealItems
        )
        
        return MealSection(
            selectedMealItemForMove: $selectedMealItemForMove,
            mealSectionModel: model,
            mainViewModel: mainViewModel
        )
    }
}
