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
    var renderingMode: SymbolRenderingMode = .hierarchical
    
    var formattedValue: String {
        value.asWhole()
    }
    
    var body: some View {
        if let image {
            HStack(spacing: 2.5) {
                Image(systemName: image)
                    .symbolRenderingMode(renderingMode)
                    .symbolColorRenderingMode(.gradient)
                    .imageScale(.medium)
                
                Text(formattedValue)
                    .font(.subheadline)
                
                Text(unit.description(for: value))
                    .font(.subheadline)
            }
            .foregroundStyle(color)
            .padding(.trailing, 2.5)
        } else if let label {
            HStack(spacing: 2.5) {
                Text(label)
                
                HStack(spacing: 2.5) {
                    Text(formattedValue)
                    Text(unit.description(for: value))
                }
            }
            .font(.subheadline)
            .foregroundStyle(Color.secondary)
            .padding(.trailing, 2.5)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
