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
    let isBookmarked: Bool
    
    init(
        foodName: String,
        formattedText: String,
        calories: Double? = nil,
        fat: Double,
        carbs: Double,
        protein: Double,
        isBookmarked: Bool = false
    ) {
        self.foodName = foodName
        self.formattedText = formattedText
        self.calories = calories
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
        self.isBookmarked = isBookmarked
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                Text(foodName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)
            }
            
            Text(formattedText)
                .font(.subheadline)
                .foregroundStyle(Color.secondary)
            
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
