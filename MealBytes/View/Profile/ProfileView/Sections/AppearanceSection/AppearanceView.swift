//
//  AppearanceView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30.03.2026.
//

import SwiftUI

struct AppearanceView: View {
    @ObservedObject var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Form {
            Section {
                ForEach([ThemeMode.light, .dark], id: \.self) { theme in
                    ThemeButton(
                        theme: theme,
                        text: theme.themeName,
                        isSelected: shouldShowCheckmark(for: theme),
                        themeManager: themeManager
                    ) {
                        themeManager.selectedTheme = theme
                    }
                }
                
                Toggle(isOn: Binding(
                    get: { themeManager.selectedTheme == .system },
                    set: { isOn in
                        if isOn {
                            themeManager.selectedTheme = .system
                        } else {
                            let systemIsDark = colorScheme == .dark
                            themeManager.selectedTheme = systemIsDark
                            ? .dark
                            : .light
                        }
                    }
                )) {
                    Text("System")
                }
            } footer: {
                Text("Enable for appearance to follow system settings")
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func shouldShowCheckmark(for theme: ThemeMode) -> Bool {
        if themeManager.selectedTheme == .system {
            return theme == (colorScheme == .dark ? .dark : .light)
        } else {
            return themeManager.selectedTheme == theme
        }
    }
}

#Preview {
    NavigationStack {
        AppearanceView(themeManager: ThemeManager())
    }
}
