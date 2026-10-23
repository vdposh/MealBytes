//
//  FoodDetailView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/03/2025.
//

import SwiftUI

struct FoodDetailView: View {
    let food: Food
    var foodMetadata: FoodMetadata? = nil
    var energyUnit: EnergyUnit = .kcal
    var showChevron: Bool = true
    
    var body: some View {
        HStack(spacing: 10) {
            if let metadata = foodMetadata {
                FoodItemView(
                    foodName: food.searchFoodName,
                    formattedText: MealItemTextFormatter.format(
                        amountValue: Double(metadata.amount) ?? 0,
                        measurement: metadata.measurementDescription,
                        servingSize: metadata.metricServingAmount,
                        unit: metadata.metricServingUnit
                    ),
                    calories: energyUnit.fromKcal(kcal: metadata.calories),
                    fat: metadata.fat,
                    carbs: metadata.carbs,
                    protein: metadata.protein
                )
            } else if let nutrients = food.parsedNutrients {
                FoodItemView(
                    foodName: food.searchFoodName,
                    formattedText: nutrients.description,
                    calories: energyUnit.fromKcal(kcal: nutrients.calories),
                    fat: nutrients.fat,
                    carbs: nutrients.carbs,
                    protein: nutrients.protein
                )
            }
            
            if showChevron {
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.placeholderText))
                    .padding(.trailing, 2)
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
