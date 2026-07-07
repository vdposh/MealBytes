//
//  NutrientLabel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct NutrientLabel: View {
    var image: String
    var value: Double = 0
    var color: Color = .secondary
    
    var body: some View {
        HStack(spacing: 2.5) {
            Image(systemName: image)
            
            Text(value.asWhole())
                .fontWeight(.medium)
        }
        .font(.footnote)
        .foregroundStyle(color)
    }
}

#Preview {
    PreviewContentView.contentView
}
