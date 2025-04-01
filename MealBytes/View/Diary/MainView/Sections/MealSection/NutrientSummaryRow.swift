//
//  NutrientSummaryRow.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct NutrientSummaryRow: View {
    let fat: Double
    let carbohydrate: Double
    let protein: Double
    let calories: Double
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        HStack {
            let nutrients = mainViewModel.formattedNutrients(
                source: .details(
                    fat: fat,
                    carbohydrate: carbohydrate,
                    protein: protein
                )
            )
            ForEach(["F", "C", "P"], id: \.self) { label in
                NutrientLabel(
                    label: label,
                    formattedValue: nutrients[label] ?? ""
                )
            }
            if mainViewModel.canDisplayRdi() {
                Text(mainViewModel.rdiPercentageText(for: calories))
                    .lineLimit(1)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
