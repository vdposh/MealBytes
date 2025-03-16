//
//  NutrientRow.swift
//  MealBytes
//
//  Created by Porshe on 15/03/2025.
//

import SwiftUI

// MARK: - Displays a row showing nutritional information, including fats, carbohydrates, and proteins with formatted values
struct NutrientRow: View {
    let fats: Double
    let carbs: Double
    let proteins: Double
    private let formatter = Formatter()

    var body: some View {
        HStack {
            Text("F")
                .foregroundColor(.gray)
            Text(formatter.formattedValue(fats, unit: .empty))
                .foregroundColor(.gray)
            Text("C")
                .foregroundColor(.gray)
                .padding(.leading, 5)
            Text(formatter.formattedValue(carbs, unit: .empty))
                .foregroundColor(.gray)
            Text("P")
                .foregroundColor(.gray)
                .padding(.leading, 5)
            Text(formatter.formattedValue(proteins, unit: .empty))
                .foregroundColor(.gray)
            Spacer()
        }
    }
}
