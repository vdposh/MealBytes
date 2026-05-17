//
//  NutrientLabel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct NutrientLabel: View {
    let formattedValue: String
    var label: String? = nil
    var image: String? = nil
    var color: Color = .secondary
    
    var body: some View {
        if let image {
            Label {
                Text(formattedValue)
                    .foregroundStyle(color)
                    .font(.subheadline)
                    .fontWeight(.medium)
            } icon: {
                Image(systemName: image)
                    .foregroundStyle(color)
                    .symbolRenderingMode(.monochrome)
                    .symbolColorRenderingMode(.gradient)
                    .imageScale(.medium)
            }
            .labelIconToTitleSpacing(2)
        } else if let label {
            Text(label)
                .foregroundStyle(Color.secondary)
                .font(.subheadline)
            
            Text(formattedValue)
                .foregroundStyle(Color.secondary)
                .font(.subheadline)
                .padding(.trailing, 5)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
