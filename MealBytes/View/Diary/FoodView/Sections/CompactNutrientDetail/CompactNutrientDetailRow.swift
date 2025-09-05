//
//  CompactNutrientDetailRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct CompactNutrientDetailRow: View {
    let nutrient: CompactNutrientDetail
    
    var body: some View {
        VStack(spacing: 9) {
            Text(nutrient.type.alternativeTitle)
                .font(.footnote)
                .foregroundStyle(.secondary)
            
            Text(nutrient.formattedValue)
                .font(.callout)
                .fontWeight(.medium)
        }
        .lineLimit(1)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PreviewFoodView.foodView
}
