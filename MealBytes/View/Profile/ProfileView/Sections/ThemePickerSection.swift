//
//  ThemePickerSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct ThemePickerSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Section {
            Picker("App Theme", selection: $themeManager.selectedTheme) {
                ForEach(ThemeMode.allCases, id: \.self) { theme in
                    Text(theme.themeName)
                        .tag(theme)
                }
            }
            .pickerStyle(.navigationLink)
        } footer: {
            Text("Choose a theme to customize the app's appearance. The automatic mode follows system settings.")
        }
    }
}

#Preview {
    PreviewProfileView.profileView
}
