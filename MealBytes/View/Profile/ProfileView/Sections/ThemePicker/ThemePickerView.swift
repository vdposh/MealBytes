//
//  ThemePickerView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30.03.2026.
//

import SwiftUI

struct ThemePickerView: View {
    @ObservedObject var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Form {
            Section {
                ThemeButton(
                    theme: .light,
                    text: "Light",
                    isSelected: shouldShowCheckmark(for: .light),
                    themeManager: themeManager
                ) {
                    themeManager.selectedTheme = .light
                }
                
                ThemeButton(
                    theme: .dark,
                    text: "Dark",
                    isSelected: shouldShowCheckmark(for: .dark),
                    themeManager: themeManager
                ) {
                    themeManager.selectedTheme = .dark
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
                .toggleStyle(SwitchToggleStyle(tint: .accent))
            } footer: {
                Text("Enable for app theme to follow your system settings")
            }
        }
        .navigationTitle("App Theme")
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
        ThemePickerView(themeManager: ThemeManager())
    }
}

#Preview {
    PreviewProfileView.profileView
}

#Preview {
    PreviewContentView.contentView
}
