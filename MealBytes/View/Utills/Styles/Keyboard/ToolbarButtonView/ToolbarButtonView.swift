//
//  ToolbarButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24.08.2026.
//

import SwiftUI

struct ToolbarButtonView: View {
    var icon: String = "checkmark"
    let action: () -> Void
    var alignment: Alignment = .leading
    var focused: Bool = false
    var isActive: Bool = true
    var isArrows: Bool = false
    
    private var button: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 50, height: 50)
                .foregroundStyle(isActive ? Color.primary : Color(.systemGray2))
        }
        .disabled(!isActive)
    }
    
    var body: some View {
        if isArrows {
            button
        } else {
            button
                .glassEffect(.regular.interactive(), in: .circle)
                .frame(
                    maxWidth: alignment == .center ? nil : .infinity,
                    alignment: alignment
                )
                .padding(
                    .horizontal,
                    UIScreen.horizontalPadding(focused: focused)
                )
                .padding(.bottom, focused ? 10 : 26)
                .animation(.default, value: focused)
        }
    }
}

#Preview {
    PreviewGoalsView.goalsView
}

#Preview {
    PreviewFoodView.foodView
}

#Preview {
    PreviewContentView.contentView
}
