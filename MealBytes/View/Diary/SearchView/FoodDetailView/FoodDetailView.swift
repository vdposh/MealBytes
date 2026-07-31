//
//  FoodDetailView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/03/2025.
//

import SwiftUI

struct FoodDetailView: View {
    let food: Food
    let isEditing: Bool
    @ObservedObject var searchViewModel: SearchViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            if !isEditing {
                ZStack {
                    if searchViewModel.isBookmarkedSearchView(food) {
                        Image(systemName: "bookmark.fill")
                            .imageScale(.small)
                            .foregroundStyle(.accent)
                            .symbolColorRenderingMode(.gradient)
                    }
                }
                .frame(width: 5)
            }
            
            if let nutrients = food.parsedNutrients {
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
}

#Preview {
    PreviewContentView.contentView
}
