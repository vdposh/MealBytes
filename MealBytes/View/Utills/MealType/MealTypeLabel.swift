//
//  MealTypeLabel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06.05.2026.
//

import SwiftUI

struct MealTypeLabel: View {
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
            Image(systemName: mealType.iconName)
                .font(.title3)
                .foregroundStyle(
                    mealType.foregroundStyle.0,
                    mealType.foregroundStyle.1
                )
                .symbolRenderingMode(mealType.renderingMode)
                .symbolColorRenderingMode(.gradient)
        }
        .labelIconToTitleSpacing(15)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PreviewContentView.contentView
}
