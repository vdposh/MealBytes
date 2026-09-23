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
        SelectionRow(
            title: text,
            isSelected: isSelected,
            checkmarkColor: isSelected && themeManager.selectedTheme != .system
            ? .accent
            : Color(.systemGray4)
        ) {
            action()
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
