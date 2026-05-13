//
//  NutrientLabel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct NutrientLabel: View {
    let label: String
    let formattedValue: String
    
    var body: some View {
        Text(label)
            .foregroundStyle(Color.secondary)
            .font(.subheadline)
//        Image(systemName: "f.circle.fill")
//            .foregroundStyle(.customStar)
//            .symbolRenderingMode(.monochrome)
//            .symbolColorRenderingMode(.gradient)
        
        Text(formattedValue)
            .foregroundStyle(Color.secondary)
            .font(.subheadline)
            .padding(.trailing, 5)
    }
}

#Preview {
    PreviewContentView.contentView
}
