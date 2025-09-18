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
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity, minHeight: 45)
                .background(
                    isEnabled
                    ? Color.accentColor.opacity(1)
                    : color.opacity(
                        colorScheme == .light ? 0.5 : 0.6
                    )
                )
                .saturation(colorScheme == .dark && !isEnabled ? 0.5 : 1)
                .foregroundStyle(
                    Color.white.opacity(
                        isEnabled ? 1 : (colorScheme == .dark ? 0.3 : 0.5)
                    )
                )
                .font(.headline)
                .lineLimit(1)
                .cornerRadius(18)
        }
        .buttonStyle(.borderless)
        .accentColor(color)
        .disabled(!isEnabled)
    }
}

#Preview {
    PreviewFoodView.foodView
}

#Preview {
    PreviewContentView.contentView
}
