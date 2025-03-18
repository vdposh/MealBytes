//
//  FoodItemRow.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct FoodItemRow: View {
    let mealItem: MealItem
    let mainViewModel: MainViewModel
    let mealType: MealType
    
    var body: some View {
        NavigationLink(
            destination: FoodView(
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
                showCloseButton: false
            )
        ) {
            VStack(spacing: 10) {
                HStack {
                    Text(mealItem.foodName)
                        .lineLimit(1)
                        .fontWeight(.medium)
                        .frame(width: 120, alignment: .leading)
                    Group {
                        Text(mainViewModel.formattedServingSize(for: mealItem))
                        Text(mealItem.portionUnit)
                    }
                    .foregroundColor(.gray)
                    Spacer()
                    Text(mainViewModel.formatter.formattedValue(
                        mealItem.nutrients[.calories] ?? 0.0,
                        unit: .empty,
                        alwaysRoundUp: true
                    ))
                    .fontWeight(.medium)
                }
                HStack {
                    NutrientLabel(
                        label: "F",
                        formattedValue: mainViewModel.formatter.formattedValue(
                            mealItem.nutrients[.fat] ?? 0.0,
                            unit: .empty
                        )
                    )
                    NutrientLabel(
                        label: "C",
                        formattedValue: mainViewModel.formatter.formattedValue(
                            mealItem.nutrients[.carbohydrates] ?? 0.0,
                            unit: .empty
                        )
                    )
                    NutrientLabel(
                        label: "P",
                        formattedValue: mainViewModel.formatter.formattedValue(
                            mealItem.nutrients[.protein] ?? 0.0,
                            unit: .empty
                        )
                    )
                    Spacer()
                }
            }
            .padding(.vertical, 5)
            .padding(.trailing, 5)
        }
    }
}

#Preview {
    MainView()
}
