//
//  NutrientSummaryRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct NutrientSummaryRow: View {
    let fat: Double
    let carbs: Double
    let protein: Double
    let calories: Double
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        HStack {
//            NutrientLabel(
//                label: "F",
//                value: fat
//            )
//            NutrientLabel(
//                label: "C",
//                value: carbs
//            )
//            NutrientLabel(
//                label: "P",
//                value: protein
//            )
            
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
