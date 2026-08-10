//
//  ThemeButton.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30.03.2026.
//

import SwiftUI

struct ThemeButton: View {
    let theme: ThemeMode
    let text: String
    let isSelected: Bool
    let themeManager: ThemeManager
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .foregroundStyle(Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing, 32)
                .overlay(alignment: .trailing) {
                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.headline)
                            .foregroundStyle(
                                isSelected && themeManager.selectedTheme != .system
                                ? .accent
                                : Color(.systemGray4)
                            )
                    }
                }
        }
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
