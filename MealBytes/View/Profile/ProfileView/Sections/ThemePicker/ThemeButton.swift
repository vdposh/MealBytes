//
//  ThemeButton.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30.03.2026.
//

import SwiftUI

struct ThemeButton: View {
    let theme: ThemeMode
    let imageName: String
    let label: String
    let isSelected: Bool
    let isAutomaticEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text(label)
                
                Image(
                    systemName: isSelected ? "checkmark.circle.fill" : "circle"
                )
                .foregroundStyle(
                    isSelected && !isAutomaticEnabled
                    ? .accent
                    : .secondary
                )
                .font(.title2)
                .contentTransition(
                    isSelected
                    ? .symbolEffect(.replace.magic(fallback: .replace))
                    : .identity
                )
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        ThemePickerView(themeManager: ThemeManager())
    }
}

#Preview {
    PreviewProfileView.profileView
}

#Preview {
    PreviewContentView.contentView
}
