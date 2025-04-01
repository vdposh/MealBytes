//
//  FoodItemRow.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct FoodItemRow: View {
    @Binding var isDismissed: Bool
    let mealItem: MealItem
    let mealType: MealType
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        NavigationLink(
            destination: FoodView(
                isDismissed: $isDismissed,
                navigationTitle: "Edit in Diary",
                food: Food(
                    searchFoodId: mealItem.foodId,
                    searchFoodName: mealItem.foodName,
                    searchFoodDescription: ""
                ),
                searchViewModel: mainViewModel.searchViewModel,
                mainViewModel: mainViewModel,
                mealType: mealType,
                amount: String(mealItem.amount),
                measurementDescription: mealItem.measurementDescription,
                showAddButton: false,
                showSaveRemoveButton: true,
                showCloseButton: false,
                originalMealItemId: mealItem.id
            )
        ) {
            VStack(spacing: 10) {
                HStack {
                    Text(mealItem.foodName)
                        .lineLimit(1)
                        .font(.callout)
                        .fontWeight(.medium)
                    HStack(spacing: 2) {
                        Text(mainViewModel.formattedServingSize(for: mealItem))
                        Text(mealItem.portionUnit)
                    }
                    .lineLimit(1)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    
                    Text(mainViewModel.formatter.formattedValue(
                        mealItem.nutrients[.calories],
                        unit: .empty,
                        alwaysRoundUp: true
                    ))
                    .lineLimit(1)
                    .font(.callout)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                HStack {
                    NutrientLabel(
                        label: "F",
                        formattedValue: mainViewModel.formatter.formattedValue(
                            mealItem.nutrients[.fat],
                            unit: .empty
                        )
                    )
                    NutrientLabel(
                        label: "C",
                        formattedValue: mainViewModel.formatter.formattedValue(
                            mealItem.nutrients[.carbohydrate],
                            unit: .empty
                        )
                    )
                    NutrientLabel(
                        label: "P",
                        formattedValue: mainViewModel.formatter.formattedValue(
                            mealItem.nutrients[.protein],
                            unit: .empty
                        )
                    )
                    if mainViewModel.canDisplayRdi() {
                        Text(mainViewModel.rdiPercentageText(
                            for: mealItem.nutrients[.calories]))
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 5)
            .padding(.trailing, 5)
        }
    }
}
