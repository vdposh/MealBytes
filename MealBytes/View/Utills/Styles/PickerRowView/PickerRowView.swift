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
    @ViewBuilder let menuContent: () -> MenuContent
    
    var body: some View {
        HStack {
            Label {
                Text(title)
            } icon: {
                if useRendering {
                    Image(systemName: iconName)
                        .imageScale(.large)
                        .foregroundStyle(
                            mealType.foregroundStyle.0,
                            mealType.foregroundStyle.1
                        )
                        .symbolColorRenderingMode(.gradient)
                        .symbolRenderingMode(mealType.renderingMode)
                } else {
                    Image(systemName: iconName)
                        .imageScale(.medium)
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
                        .fill(Color.accent.opacity(0.2))
                        .frame(width: 30, height: 30)
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.accent)
                }
            }
            .glassEffect(.regular.interactive())
            .buttonStyle(ButtonStyleInvisible())
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
