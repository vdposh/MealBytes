//
//  PickerRowView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/10/2025.
//

import SwiftUI

struct PickerRowView<MenuContent: View>: View {
    let title: String
    let iconName: String
    let mealType: MealType
    let useRendering: Bool
    @Environment(\.colorScheme) var colorScheme
    @ViewBuilder let menuContent: () -> MenuContent
    
    var body: some View {
        HStack {
            Label {
                Text(title)
            } icon: {
                if useRendering {
                    let colors = mealType.colors(for: colorScheme)
                    
                    Image(systemName: iconName)
                        .imageScale(.large)
                        .foregroundStyle(colors.secondary, colors.primary)
                        .symbolRenderingMode(mealType.symbolRendering)
                        .symbolColorRenderingMode(.gradient)
                } else {
                    Image(systemName: iconName)
                        .foregroundStyle(.customGray)
                        .symbolColorRenderingMode(.gradient)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Color.clear
                .frame(width: 30)
        }
        .overlay(alignment: .trailing) {
            Menu(content: menuContent) {
                ZStack {
                    Circle()
                        .fill(Color.accent.opacity(0.2).gradient)
                        .frame(width: 30, height: 30)
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.accent)
                        .symbolColorRenderingMode(.gradient)
                }
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
