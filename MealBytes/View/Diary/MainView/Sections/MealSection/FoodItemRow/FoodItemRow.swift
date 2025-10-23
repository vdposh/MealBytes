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
                amount: String(mealItem.amount),
                measurementDescription: mealItem.measurementDescription,
                showAddButton: false,
                showSaveRemoveButton: true,
                originalCreatedAt: mealItem.createdAt,
                originalMealItemId: mealItem.id
            )
        } label: {
            HStack {
                VStack(spacing: 5) {
                    HStack(spacing: 10) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(mealItem.foodName)
                                .foregroundStyle(Color.primary)
                            Text(
                                mainViewModel.formattedMealText(for: mealItem)
                            )
                            .font(.subheadline)
                            .foregroundStyle(.accent)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .layoutPriority(0)
                        
                        Text(mainViewModel.formatter.formattedValue(
                            mealItem.nutrients[.calories],
                            unit: .empty,
                            alwaysRoundUp: true
                        ))
                        .lineLimit(1)
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.secondary)
                        .layoutPriority(1)
                    }
                    
                    HStack {
                        NutrientLabel(
                            label: "F",
                            formattedValue: mainViewModel
                                .formatter.formattedValue(
                                    mealItem.nutrients[.fat],
                                    unit: .empty
                                )
                        )
                        NutrientLabel(
                            label: "C",
                            formattedValue: mainViewModel
                                .formatter.formattedValue(
                                    mealItem.nutrients[.carbohydrate],
                                    unit: .empty
                                )
                        )
                        NutrientLabel(
                            label: "P",
                            formattedValue: mainViewModel
                                .formatter.formattedValue(
                                    mealItem.nutrients[.protein],
                                    unit: .empty
                                )
                        )
                        if mainViewModel.canDisplayIntake() {
                            Text(
                                mainViewModel
                                    .intakePercentage(
                                        for: mealItem.nutrients[.calories]
                                    )
                            )
                            .lineLimit(1)
                            .foregroundStyle(Color.secondary)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
