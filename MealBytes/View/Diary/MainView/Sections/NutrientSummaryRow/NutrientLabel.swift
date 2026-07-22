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
    var fontImage: Font = .subheadline
    var color: Color = .customCalories
    
    var formattedValue: String {
        value.asWhole()
    }
    
    var body: some View {
        if let image {
            HStack(spacing: 2.5) {
                Image(systemName: image)
                    .font(fontImage)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(color)
                
                Text(formattedValue)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundStyle(color)
            }
        } else if let label {
            Text("\(label) \(formattedValue) g")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.trailing, 5)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
