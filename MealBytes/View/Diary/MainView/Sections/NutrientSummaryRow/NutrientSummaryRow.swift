//
//  NutrientSummaryRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct NutrientSummaryRow: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    let calories: Double?
    let fat: Double
    let carbs: Double
    let protein: Double
    
    init(
        mainViewModel: MainViewModel,
        calories: Double? = nil,
        fat: Double,
        carbs: Double,
        protein: Double
    ) {
        self.mainViewModel = mainViewModel
        self.calories = calories
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
    }
    
    var body: some View {
        HStack(spacing: 10) {
            if let calories {
                NutrientLabel(
                    image: "flame.fill",
                    value: calories,
                    fontImage: .system(size: 13)
                )
            }
            
            NutrientLabel(
                image: "f.circle.fill",
                value: fat,
                color: .customFat
            )
            
            NutrientLabel(
                image: "c.circle.fill",
                value: carbs,
                color: .customCarbs
            )
            
            NutrientLabel(
                image: "p.circle.fill",
                value: protein,
                color: .customProtein
            )
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PreviewContentView.contentView
}
