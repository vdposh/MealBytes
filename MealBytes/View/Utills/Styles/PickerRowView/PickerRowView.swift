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
    @ViewBuilder let menuContent: () -> MenuContent
    
    var body: some View {
        HStack {
            Label {
                Text(title)
            } icon: {
                Image(systemName: iconName)
                    .font(.system(size: 14))
                    .foregroundStyle(.accent.opacity(0.8))
            }
            .labelIconToTitleSpacing(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            
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
        .frame(height: 20)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
