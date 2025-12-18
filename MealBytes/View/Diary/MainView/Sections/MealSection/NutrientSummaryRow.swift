//
//  NutrientSummaryRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
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
            
            if mainViewModel.canDisplayIntake() {
                Text(mainViewModel.intakePercentage(for: calories))
                    .foregroundStyle(Color.secondary)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PreviewContentView.contentView
}
