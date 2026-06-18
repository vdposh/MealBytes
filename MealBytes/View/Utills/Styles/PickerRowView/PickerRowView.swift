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
    @Environment(\.colorScheme) var colorScheme
    @ViewBuilder let menuContent: () -> MenuContent
    
    var body: some View {
        HStack {
            Label {
                Text(title)
            } icon: {
                Image(systemName: iconName)
                    .foregroundStyle(.customGray)
                    .symbolColorRenderingMode(.gradient)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Color.clear
                .frame(width: 30)
        }
        .overlay(alignment: .trailing) {
            Menu(content: menuContent) {
                ZStack {
                    Circle()
                        .fill(Color(.systemGroupedBackground))
                        .frame(width: 30, height: 30)
                    Image(systemName: "ellipsis")
                        .foregroundStyle(.opacity(0.6))
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
