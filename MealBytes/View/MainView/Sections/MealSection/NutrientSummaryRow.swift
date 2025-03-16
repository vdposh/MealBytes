//
//  NutrientSummaryRow.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

// MARK: - Displays a summary row for macronutrients, including fats, carbohydrates, and proteins with formatted labels
struct NutrientSummaryRow: View {
    let fats: Double
    let carbs: Double
    let proteins: Double
    let formatter: Formatter
    
    var body: some View {
        HStack {
            NutrientLabel(label: "F", value: fats, formatter: formatter)
            NutrientLabel(label: "C", value: carbs, formatter: formatter)
                .padding(.leading, 5)
            NutrientLabel(label: "P", value: proteins, formatter: formatter)
                .padding(.leading, 5)
            Spacer()
        }
    }
}
