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
        VStack {
            Text(nutrient.type.alternativeTitle)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.bottom, 1)
            HStack {
                Text(nutrient.formattedValue)
                    .lineLimit(1)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 78)
        .frame(maxWidth: .infinity)
        .background(.customGreen)
        .cornerRadius(12)
    }
}
