//
//  MealSection.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct MealSection: View {
    let model: MealSectionModel
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        MealHeaderView(
            mealType: model.mealType,
            title: model.title,
            iconName: model.iconName,
            color: model.color,
            calories: model.calories,
            fats: model.fats,
            proteins: model.proteins,
            carbohydrates: model.carbohydrates,
            foodItems: model.foodItems,
            mainViewModel: mainViewModel
        )
    }
}

#Preview {
    MainView()
}
