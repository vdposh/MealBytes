//
//  PreviewFoodView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/09/2025.
//

import SwiftUI

struct PreviewFoodView {
    static var foodView: some View {
        let mainViewModel = MainViewModel()
        let searchViewModel = SearchViewModel(mainViewModel: mainViewModel)
        let food = Food(
            searchFoodId: 3092,
            searchFoodName: "Egg",
            searchFoodDescription: "1 cup"
        )
        
        return NavigationStack {
            FoodView(
                navigationTitle: "Add to Diary",
                food: food,
                searchViewModel: searchViewModel,
                mainViewModel: mainViewModel,
                mealType: .breakfast,
                amount: "1",
                measurementDescription: "Grams",
                showAddButton: true,
                showSaveRemoveButton: true,
                showMealTypeButton: true,
                originalMealItemId: UUID()
            )
        }
    }
}

#Preview {
    PreviewFoodView.foodView
}
