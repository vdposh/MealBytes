//
//  MealTypeLabel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06.05.2026.
//

import SwiftUI

struct MealTypeLabel: View {
    @Environment(\.colorScheme) var colorScheme
    
    let mealType: MealType
    var title: String?
    var isHeader: Bool = false
    
    var body: some View {
        Label {
            Text(title ?? mealType.rawValue)
                .font(isHeader ? .system(size: 18) : nil)
                .fontWeight(isHeader ? .medium : nil)
                .foregroundStyle(Color.primary)
        } icon: {
            let colors = mealType.colors(for: colorScheme)
            
            Image(systemName: mealType.iconName)
                .imageScale(.large)
                .foregroundStyle(colors.secondary, colors.primary)
                .symbolRenderingMode(mealType.symbolRendering)
                .symbolColorRenderingMode(.gradient)
        }
        .labelIconToTitleSpacing(12.5)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PreviewContentView.contentView
}
