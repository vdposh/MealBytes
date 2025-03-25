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
    let mainViewModel: MainViewModel
    
    var body: some View {
        NavigationLink(
            destination: FoodView(
                isDismissed: $isDismissed,
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
                        mealItem.nutrients[.calories] ?? 0.0,
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
                            mealItem.nutrients[.fat] ?? 0.0,
                            unit: .empty
                        )
                    )
                    NutrientLabel(
                        label: "C",
                        formattedValue: mainViewModel.formatter.formattedValue(
                            mealItem.nutrients[.carbohydrate] ?? 0.0,
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
                    Spacer() //временно остается, справа будет еще одно значение
                }
            }
            .padding(.vertical, 5)
            .padding(.trailing, 5)
        }
    }
}

#Preview {
    NavigationStack {
        FoodItemRow(
            isDismissed: .constant(false),
            mealItem: MealItem(
                id: UUID(),
                foodId: 724,
                foodName: "Banana",
                portionUnit: "g",
                nutrients: [
                    .calories: 89.0,
                    .carbohydrate: 22.8,
                    .fat: 0.3,
                    .protein: 1.1
                ],
                measurementDescription: "grams",
                amount: 150.0,
                mealType: .breakfast
            ),
            mealType: .breakfast,
            mainViewModel: MainViewModel(firestoreManager: FirestoreManager())
        )
    }
    .accentColor(.primary)
}
