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
        .padding(.horizontal, focused ? 16 : 28)
        .padding(.bottom, focused ? 8 : -8)
        .animation(.default, value: focused)
    }
}

#Preview {
    PreviewFoodView.foodView
}
