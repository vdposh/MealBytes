//
//  NutrientSummaryRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct NutrientSummaryRow: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    let calories: Double
    let fat: Double
    let carbs: Double
    let protein: Double
    
    var body: some View {
        HStack(spacing: 10) {
            NutrientLabel(
                image: "flame.fill",
                value: calories,
                color: .customCalories
            )
            
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
