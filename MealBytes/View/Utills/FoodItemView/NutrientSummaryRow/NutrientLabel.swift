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
    var color: Color = .customCalories
    
    var formattedValue: String {
        value.asWhole()
    }
    
    var body: some View {
        if let image {
            HStack(spacing: 3) {
                Image(systemName: image)
                Text(formattedValue)
                    .fontWeight(.medium)
            }
            .font(.footnote)
            .foregroundStyle(color)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
