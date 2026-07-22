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
        foodItemContent
            .contextMenu {
                foodItemContextMenu
            }
    }
    
    private var foodItemContent: some View {
        NavigationLink {
            FoodView(
                mealType: mealItem.mealType,
                food: Food(
                    searchFoodId: mealItem.foodId,
                    searchFoodName: mealItem.foodName,
                    searchFoodDescription: ""
                ),
                searchViewModel: mainViewModel.searchViewModel,
                mainViewModel: mainViewModel,
                amount: mealItem.amount.asDecimal(grouping: false),
                measurementDescription: mealItem.measurementDescription,
                isEditingMealItem: true,
                originalCreatedAt: mealItem.createdAt,
                originalMealItemId: mealItem.id
            )
        } label: {
            VStack(alignment: .leading) {
                Text(mealItem.foodName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(mainViewModel.formattedMealText(for: mealItem))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                NutrientSummaryRow(
                    mainViewModel: mainViewModel,
                    calories: mealItem.caloriesValue,
                    fat: mealItem.fatValue,
                    carbs: mealItem.carbsValue,
                    protein: mealItem.proteinValue
                )
            }
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
