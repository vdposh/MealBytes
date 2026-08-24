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
    var amountFocused: Bool = false
    
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
        .padding(.horizontal, amountFocused ? 16 : 30)
        .padding(.bottom, amountFocused ? 10 : -10)
        .animation(.default, value: amountFocused)
    }
}

#Preview {
    PreviewFoodView.foodView
}
