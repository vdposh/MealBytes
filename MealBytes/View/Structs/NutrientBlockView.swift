//
//  NutrientBlockView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct NutrientBlockView: View {
    let title: String
    let value: Double
    let unit: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.vertical, 1)
            HStack {
                Text(Formatter.formattedValue(value,
                                              unit: unit,
                                              roundToInt: true,
                                              includeSpace: false))
                .lineLimit(1)
                .foregroundColor(.white)
            }
        }
        .frame(height: 73)
        .frame(maxWidth: .infinity)
        .background(.customGreen)
        .cornerRadius(12)
    }
}
