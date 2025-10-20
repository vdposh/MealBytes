//
//  CompactNutrientValueRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct CompactNutrientValueRow: View {
    let nutrient: CompactNutrientValue
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Text(nutrient.type.alternativeTitle)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                
                Text(nutrient.unitDescription)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            
            Text(nutrient.formattedCompactNutrientValue)
                .fontWeight(.medium)
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
