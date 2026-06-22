//
//  NutrientLabel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct NutrientLabel: View {
    var label: String? = nil
    var image: String? = nil
    var value: Double = 0
    var unit: UnitNutrients = .g
    var color: Color = .secondary
    
    var formattedValue: String {
        value.asWhole()
    }
    
    var body: some View {
        if let image {
            HStack(spacing: 2.5) {
                Image(systemName: image)
                
                Text(formattedValue)
                    .fontWeight(.medium)
            }
            .font(.footnote)
            .foregroundStyle(color)
        } else if let label {
            Text("\(label) \(formattedValue) \(unit.description(for: value))")
                .font(.subheadline)
                .foregroundStyle(color)
                .padding(.trailing, 5)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
