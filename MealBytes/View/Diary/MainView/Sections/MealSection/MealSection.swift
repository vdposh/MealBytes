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
            mealType: mealSectionModel.mealType,
            title: mealSectionModel.title,
            iconName: mealSectionModel.iconName,
            calories: mealSectionModel.calories,
            fat: mealSectionModel.fat,
            protein: mealSectionModel.protein,
            carbohydrate: mealSectionModel.carbohydrate,
            selectedMealItemForMove:$selectedMealItemForMove,
            mainViewModel: mainViewModel
        )
    }
}
