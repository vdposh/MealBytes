//
//  MealSectionView.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct MealSectionView: View {
    let mealType: MealType
    let mealItems: [MealItem]
    let viewModel: MainViewModel
    
    var body: some View {
        MealSection(
            mealType: mealType,
            title: mealType.rawValue,
            iconName: mealType.iconName,
            color: mealType.color,
            calories: mealItems.reduce(0) {
                $0 + $1.nutrients.value(for: .calories) },
            fats: mealItems.reduce(0) {
                $0 + $1.nutrients.value(for: .fat) },
            proteins: mealItems.reduce(0) {
                $0 + $1.nutrients.value(for: .protein) },
            carbohydrates: mealItems.reduce(0) {
                $0 + $1.nutrients.value(for: .carbohydrates) },
            foodItems: mealItems,
            mainViewModel: viewModel
        )
    }
}
