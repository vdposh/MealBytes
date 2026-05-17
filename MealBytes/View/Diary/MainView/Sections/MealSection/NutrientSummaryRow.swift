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
            NutrientLabel(
                label: "F",
                formattedValue: fat.asNutrient()
            )
            NutrientLabel(
                label: "C",
                formattedValue: carbs.asNutrient()
            )
            NutrientLabel(
                label: "P",
                formattedValue: protein.asNutrient()
            )
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PreviewContentView.contentView
}
