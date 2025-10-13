//
//  MealSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/03/2025.
//

import SwiftUI

struct MealSection: View {
    let mealSectionModel: MealSectionModel
    let mainViewModel: MainViewModel
    
    var body: some View {
        MealHeaderView(
            mealType: mealSectionModel.mealType,
            title: mealSectionModel.title,
            iconName: mealSectionModel.iconName,
            color: mealSectionModel.color,
            calories: mealSectionModel.calories,
            fat: mealSectionModel.fat,
            protein: mealSectionModel.protein,
            carbohydrate: mealSectionModel.carbohydrate,
            mainViewModel: mainViewModel
        )
    }
}
