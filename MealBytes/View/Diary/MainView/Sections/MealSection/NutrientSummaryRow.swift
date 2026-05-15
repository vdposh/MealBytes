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
                formattedValue: mainViewModel.formatter
                    .formattedValue(fat, unit: .empty)
            )
            NutrientLabel(
                label: "C",
                formattedValue: mainViewModel.formatter
                    .formattedValue(carbs, unit: .empty)
            )
            NutrientLabel(
                label: "P",
                formattedValue: mainViewModel.formatter
                    .formattedValue(protein, unit: .empty)
            )
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PreviewContentView.contentView
}
