//
//  CompactNutrientDetailRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct CompactNutrientDetailRow: View {
    let nutrient: CompactNutrientDetail
    
    var body: some View {
        VStack(spacing: 10) {
            Text(nutrient.type.alternativeTitle)
                .font(.footnote)
                .foregroundStyle(.secondary)
            
            Text(nutrient.formattedValue)
                .font(.callout)
                .fontWeight(.medium)
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity)
        .frame(height: 80)
    }
}

#Preview {
    NavigationStack {
        FoodView(
            navigationTitle: "Add to Diary",
            food: Food(
                searchFoodId: 3092,
                searchFoodName: "Egg",
                searchFoodDescription: "1 cup"
            ),
            searchViewModel: SearchViewModel(mainViewModel: MainViewModel()),
            mainViewModel: MainViewModel(),
            mealType: .breakfast,
            amount: "1",
            measurementDescription: "Grams",
            showAddButton: false,
            showSaveRemoveButton: true,
            showMealTypeButton: true,
            originalMealItemId: UUID()
        )
    }
}
