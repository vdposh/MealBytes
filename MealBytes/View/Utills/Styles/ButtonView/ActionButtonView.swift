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
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            isEnabled
                            ? color
                            : color.opacity(0.3)
                        )
                )
        }
        .buttonStyle(.borderless)
        .disabled(!isEnabled)
    }
}

#Preview {
    PreviewFoodView.foodView
}

#Preview {
    PreviewContentView.contentView
}
