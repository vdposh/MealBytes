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
            foodView
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
                        
                        Text(
                            mainViewModel.formatter
                                .formattedValue(
                                    mealItem.nutrients[.calories],
                                    unit: .empty,
                                    alwaysRoundUp: true
                                )
                        )
                        .lineLimit(1)
                        .layoutPriority(1)
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.secondary)
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
                            .foregroundStyle(Color.secondary)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .transaction { $0.animation = nil }
            .contextMenu {
                Menu {
                    ForEach(
                        MealType.allCases.filter { $0 != mealItem.mealType },
                        id: \.self
                    ) { mealType in
                        Button {
                            mainViewModel.moveMealItem(mealItem, to: mealType)
                        } label: {
                            Label(
                                mealType.rawValue,
                                systemImage: mealType.iconName
                            )
                        }
                    }
                } label: {
                    Label(
                        mealItem.mealType.rawValue,
                        systemImage: mealItem.mealType.iconName
                    )
                    Text("Current meal type")
                }
                
                Divider()
                
                Button(role: .destructive) {
                    mainViewModel.deleteMealItemMainView(
                        with: mealItem.id,
                        for: mealType
                    )
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
    }
    
    private var foodView: some View {
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
            isEditingMealItem: true,
            originalCreatedAt: mealItem.createdAt,
            originalMealItemId: mealItem.id
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
