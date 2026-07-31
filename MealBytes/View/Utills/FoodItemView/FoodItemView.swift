//
//  FoodItemView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 31.07.2026.
//

import SwiftUI

struct FoodItemView: View {
    let foodName: String
    let formattedText: String
    let calories: Double?
    let fat: Double
    let carbs: Double
    let protein: Double
    
    init(
        foodName: String,
        formattedText: String,
        calories: Double? = nil,
        fat: Double,
        carbs: Double,
        protein: Double
    ) {
        self.foodName = foodName
        self.formattedText = formattedText
        self.calories = calories
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(foodName)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text(formattedText)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            NutrientSummaryView(
                calories: calories,
                fat: fat,
                carbs: carbs,
                protein: protein
            )
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
