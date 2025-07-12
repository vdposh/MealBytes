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
        NavigationLink(
            destination: FoodView(
                navigationTitle: "Edit Food Entry",
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
                originalCreatedAt: mealItem.createdAt,
                originalMealItemId: mealItem.id
            )
        ) {
            VStack(spacing: 8) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(mealItem.foodName)
                        Text(mainViewModel.formattedMealText(for: mealItem))
                            .font(.subheadline)
                            .foregroundColor(.customGreen)
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
                    .foregroundColor(.secondary)
                    .layoutPriority(1)
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
            .padding(.trailing, 5)
        }
    }
}

#Preview {
    let loginViewModel = LoginViewModel()
    let mainViewModel = MainViewModel()
    let goalsViewModel = GoalsViewModel(mainViewModel: mainViewModel)

    ContentView(
        loginViewModel: loginViewModel,
        mainViewModel: mainViewModel,
        goalsViewModel: goalsViewModel
    )
    .environmentObject(ThemeManager())
}
