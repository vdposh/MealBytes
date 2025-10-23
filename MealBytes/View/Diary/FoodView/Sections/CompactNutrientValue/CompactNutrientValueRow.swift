//
//  CompactNutrientValueRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct CompactNutrientValueRow: View {
    let nutrient: CompactNutrientValue
    var intakePercentage: String? = nil
    
    var body: some View {
        VStack {
            Text(nutrient.type.alternativeTitle)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.secondary)
            
            Text(nutrient.formattedCompactNutrientValue)
                .fontWeight(.medium)
            
            if nutrient.type == .calories,
               let intakePercentage {
                Text(intakePercentage)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.tertiary)
            } else if nutrient.type != .calories {
                Text(nutrient.unitDescription)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
