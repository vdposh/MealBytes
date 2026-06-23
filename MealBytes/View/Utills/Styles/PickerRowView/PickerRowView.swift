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
        Label {
            Text(title)
        } icon: {
            Image(systemName: iconName)
                .foregroundStyle(.customGray)
                .symbolColorRenderingMode(.gradient)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.trailing, 50)
        .overlay(alignment: .trailing) {
            Menu {
                menuContent()
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundStyle(Color.secondary)
                    .padding()
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .listRowInsets(.trailing, 0)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
