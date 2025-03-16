//
//  NutrientDetailRow.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

import SwiftUI

// MARK: - Defines a view for displaying a row with detailed nutrient information, including its type, value, and whether it is a sub-value
struct NutrientDetailRow: View {
    let nutrient: NutrientDetail

    var body: some View {
        NutrientRowView(
            title: nutrient.type.title,
            value: nutrient.formattedValue,
            isSubValue: nutrient.isSubValue
        )
    }
}
