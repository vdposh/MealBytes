//
//  NutrientSummaryRow.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct NutrientSummaryRow: View {
    let fats: Double
    let carbs: Double
    let proteins: Double
    let formatter: Formatter
    
    var body: some View {
        HStack {
            NutrientLabel(label: "F", value: fats, formatter: formatter)
            NutrientLabel(label: "C", value: carbs, formatter: formatter)
                .padding(.leading, 5)
            NutrientLabel(label: "P", value: proteins, formatter: formatter)
                .padding(.leading, 5)
            Spacer()
        }
    }
}

#Preview {
    MealSection(
        title: "Breakfast",
        iconName: "sunrise.fill",
        color: .customBreakfast,
        calories: 500.0,
        fats: 20.0,
        proteins: 30.0,
        carbohydrates: 50.0,
        foodItems: [
            MealItem(
                foodId: 1,
                foodName: "Oatmeal",
                portionUnit: "g",
                nutrients: [
                    .calories: 150.0,
                    .fat: 3.0,
                    .protein: 5.0,
                    .carbohydrates: 27.0
                ],
                servingDescription: "1 cup (100g)",
                amount: 100.0
            ),
            MealItem(
                foodId: 2,
                foodName: "Banana",
                portionUnit: "g",
                nutrients: [
                    .calories: 105.0,
                    .fat: 0.3,
                    .protein: 1.3,
                    .carbohydrates: 27.0
                ],
                servingDescription: "1 medium (120g)",
                amount: 120.0
            )
        ],
        mainViewModel: MainViewModel()
    )
}
