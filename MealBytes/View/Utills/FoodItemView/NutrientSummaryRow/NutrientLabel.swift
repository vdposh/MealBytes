//
//  NutrientLabel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct NutrientLabel: View {
    var image: String? = nil
    var value: Double = 0
    var fontImage: Font = .subheadline
    var color: Color = .customCalories
    
    var formattedValue: String {
        value.asWhole()
    }
    
    var body: some View {
        if let image {
            HStack(spacing: 4) {
                Image(systemName: image)
                    .font(fontImage)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(color)
                
                Text(formattedValue)
                    .font(.footnote)
                    .fontWeight(.medium)
                    .foregroundStyle(color)
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
