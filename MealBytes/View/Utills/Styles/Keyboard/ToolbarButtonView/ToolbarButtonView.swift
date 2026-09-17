//
//  ToolbarButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24.08.2026.
//

import SwiftUI

struct ToolbarButtonView: View {
    let icon: String
    let action: () -> Void
    var alignment: Alignment = .leading
    var focused: Bool = false
    
    private var horizontalPadding: CGFloat {
        let width = UIScreen.currentSize.width
        let base: CGFloat = width < 420 ? 16 : (focused ? 20 : 16)
        return focused ? base : base * 1.75
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon)
                .font(.title2)
                .padding(12)
                .foregroundStyle(Color.primary)
        }
        .glassEffect(.regular.interactive(), in: .circle)
        .frame(
            maxWidth: alignment == .center ? nil : .infinity,
            alignment: alignment
        )
        .padding(.horizontal, horizontalPadding)
        .padding(.bottom, focused ? 8 : 26)
        .animation(.default, value: focused)
    }
}

#Preview {
    PreviewFoodView.foodView
}

#Preview {
    PreviewContentView.contentView
}
