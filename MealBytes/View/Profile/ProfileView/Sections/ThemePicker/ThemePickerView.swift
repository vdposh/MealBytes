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
                HStack(spacing: 60) {
                    ThemeButton(
                        theme: .light,
                        imageName: "themeLight",
                        label: "Light",
                        isSelected: shouldShowCheckmark(for: .light),
                        isAutomaticEnabled: themeManager
                            .selectedTheme == .automatic
                    ) {
                        themeManager.selectedTheme = .light
                    }
                    
                    ThemeButton(
                        theme: .dark,
                        imageName: "themeDark",
                        label: "Dark",
                        isSelected: shouldShowCheckmark(for: .dark),
                        isAutomaticEnabled: themeManager
                            .selectedTheme == .automatic
                    ) {
                        themeManager.selectedTheme = .dark
                    }
                }
                .frame(maxWidth: .infinity)
                
                Toggle(isOn: Binding(
                    get: { themeManager.selectedTheme == .automatic },
                    set: { isOn in
                        if isOn {
                            themeManager.selectedTheme = .automatic
                        } else {
                            let systemIsDark = colorScheme == .dark
                            themeManager.selectedTheme = systemIsDark
                            ? .dark
                            : .light
                        }
                    }
                )) {
                    Text("Automatic")
                    Text("Follows system settings")
                }
                .toggleStyle(SwitchToggleStyle(tint: .accent))
            }
            .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
        }
        .navigationTitle("App Theme")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func shouldShowCheckmark(for theme: ThemeMode) -> Bool {
        if themeManager.selectedTheme == .automatic {
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
