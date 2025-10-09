//
//  MealSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/03/2025.
//

import SwiftUI

struct MealSection: View {
    @Binding var selectedMealType: MealType?
    let mealSectionModel: MealSectionModel
    let mainViewModel: MainViewModel
    
    var body: some View {
        MealHeaderView(
            selectedMealType: $selectedMealType,
            mealType: mealSectionModel.mealType,
            title: mealSectionModel.title,
            iconName: mealSectionModel.iconName,
            color: mealSectionModel.color,
            calories: mealSectionModel.calories,
            fat: mealSectionModel.fat,
            protein: mealSectionModel.protein,
            carbohydrate: mealSectionModel.carbohydrate,
            foodItems: mealSectionModel.foodItems,
            mainViewModel: mainViewModel
        )
    }
}
