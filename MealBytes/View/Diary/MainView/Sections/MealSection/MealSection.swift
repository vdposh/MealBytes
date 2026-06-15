//
//  MealSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/03/2025.
//

import SwiftUI

struct MealSection: View {
    @Binding var selectedMealItemForMove: MealItem?
    let mealSectionModel: MealSectionModel
    let mainViewModel: MainViewModel
    
    var body: some View {
        MealHeaderView(
            selectedMealItemForMove: $selectedMealItemForMove,
            mainViewModel: mainViewModel,
            mealType: mealSectionModel.mealType,
            title: mealSectionModel.title,
            calories: mealSectionModel.calories,
            fat: mealSectionModel.fat,
            protein: mealSectionModel.protein,
            carbohydrate: mealSectionModel.carbohydrate
        )
    }
}
