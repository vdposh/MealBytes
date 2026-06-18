//
//  MealSectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct MealSectionView: View {
    @Binding var selectedMealItemForMove: MealItem?
    @ObservedObject var mainViewModel: MainViewModel
    
    let mealType: MealType
    
    var body: some View {
        let nutrients = mainViewModel.totalNutrients(for: mealType)
        
        MealHeaderView(
            selectedMealItemForMove: $selectedMealItemForMove,
            mainViewModel: mainViewModel,
            mealType: mealType,
            title: mealType.rawValue,
            calories: Double(mainViewModel.totalCalories(for: mealType)),
            fat: nutrients.fat,
            protein: nutrients.protein,
            carbohydrate: nutrients.carbs
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
