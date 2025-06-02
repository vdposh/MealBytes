//
//  MealSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/03/2025.
//

import SwiftUI

struct MealSection: View {
    let model: MealSectionModel
    let mainViewModel: MainViewModel
    
    var body: some View {
        MealHeaderView(
            mealType: model.mealType,
            title: model.title,
            iconName: model.iconName,
            color: model.color,
            calories: model.calories,
            fat: model.fat,
            protein: model.protein,
            carbohydrate: model.carbohydrate,
            foodItems: model.foodItems,
            mainViewModel: mainViewModel
        )
    }
}
