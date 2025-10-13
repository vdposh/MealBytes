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
            mainViewModel.selectedMealItem = mealItem
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
                                    .intakePercentageText(
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
                .padding(.trailing, 5)
                
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.secondary.opacity(0.5))
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
