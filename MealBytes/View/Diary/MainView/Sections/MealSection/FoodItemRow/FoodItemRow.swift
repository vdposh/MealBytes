//
//  FoodItemRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/03/2025.
//

import SwiftUI

struct FoodItemRow: View {
    let mealItem: MealItem
    let mealType: MealType
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Button {
            mainViewModel.selectedFoodItem = mealItem
        } label: {
            FoodItemView(
                foodName: mealItem.foodName,
                formattedText: mainViewModel.formattedMealText(for: mealItem),
                calories: mealItem.caloriesValue,
                fat: mealItem.fatValue,
                carbs: mealItem.carbsValue,
                protein: mealItem.proteinValue
            )
        }
        .contextMenu {
            foodItemContextMenu
        }
    }
    
    @ViewBuilder
    private var foodItemContextMenu: some View {
        Menu {
            Picker("Meal type", selection: Binding(
                get: { mealItem.mealType },
                set: { newMealType in
                    mainViewModel.moveMealItem(mealItem, to: newMealType)
                }
            )) {
                ForEach(MealType.allCases, id: \.self) { mealType in
                    Text(mealType.rawValue).tag(mealType)
                }
            }
        } label: {
            Label("Meal type", systemImage: "fork.knife")
        }
        
        Divider()
        
        Button(role: .destructive) {
            mainViewModel
                .deleteMealItemMainView(with: mealItem.id, for: mealType)
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
