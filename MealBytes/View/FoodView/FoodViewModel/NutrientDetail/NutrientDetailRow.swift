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
        HStack {
            Text(nutrient.type.title)
                .foregroundColor(nutrient.isSubValue ? .gray : .primary)
            Spacer()
            HStack {
                Text(nutrient.formattedValue)
                    .foregroundColor(nutrient.isSubValue ? .gray : .primary)
                    .lineLimit(1)
            }
        }
    }
}
