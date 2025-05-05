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
                showMealTypeButton: true,
                originalMealItemId: mealItem.id
            )
        ) {
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(mealItem.foodName)
                        Text(mainViewModel.formattedMealText(for: mealItem))
                            .foregroundColor(.customGreen)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(mainViewModel.formatter.formattedValue(
                        mealItem.nutrients[.calories],
                        unit: .empty,
                        alwaysRoundUp: true
                    ))
                    .lineLimit(1)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .frame(width: 60, alignment: .trailing)
                }
                .font(.callout)
                
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
            .padding(.trailing, 5)
        }
    }
}

#Preview {
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel()
    )
}
