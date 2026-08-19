//
//  FoodDetailView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/03/2025.
//

import SwiftUI

struct FoodDetailView: View {
    let food: Food
    var bookmarkMetadata: BookmarkMetadata? = nil
    
    var body: some View {
        if let metadata = bookmarkMetadata {
            FoodItemView(
                foodName: food.searchFoodName,
                formattedText: metadata.formattedText,
                calories: metadata.calories,
                fat: metadata.fat,
                carbs: metadata.carbs,
                protein: metadata.protein
            )
        } else if let nutrients = food.parsedNutrients {
            FoodItemView(
                foodName: food.searchFoodName,
                formattedText: nutrients.description,
                calories: nutrients.calories,
                fat: nutrients.fat,
                carbs: nutrients.carbs,
                protein: nutrients.protein
            )
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
