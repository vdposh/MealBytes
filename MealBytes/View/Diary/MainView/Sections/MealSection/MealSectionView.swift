//
//  MealSectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct MealSectionView: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    let mealType: MealType
    
    var body: some View {
        let nutrients = mainViewModel.totalNutrients(for: mealType)
        let kcal = mainViewModel.totalCalories(for: mealType)
        let displayCalories = mainViewModel.energyUnit.fromKcal(kcal: kcal)
        
        MealHeaderView(
            mainViewModel: mainViewModel,
            mealType: mealType,
            title: mealType.rawValue,
            calories: displayCalories,
            fat: nutrients.fat,
            protein: nutrients.protein,
            carbohydrate: nutrients.carbs
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
