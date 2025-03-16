//
//  NutrientLabel.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

// MARK: - Displays a label with a nutrient's name and its formatted value, styled for a clean UI
struct NutrientLabel: View {
    let label: String
    let value: Double
    let formatter: Formatter
    
    var body: some View {
        Text(label)
            .foregroundColor(.gray)
        Text(formatter.formattedValue(value, unit: .empty))
            .foregroundColor(.gray)
    }
}
