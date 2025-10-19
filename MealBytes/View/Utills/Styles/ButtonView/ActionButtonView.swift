//
//  ActionButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/03/2025.
//

import SwiftUI

struct ActionButtonView: View {
    let title: String
    let action: () -> Void
    var color: Color = .accent
    var isEnabled: Bool = true
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, minHeight: 53)
        }
        .disabled(!isEnabled)
        .glassEffect(
            .regular.interactive().tint(
                color.opacity(!isEnabled ? 0.5 : 1)
            )
        )
        .buttonStyle(.borderless)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
