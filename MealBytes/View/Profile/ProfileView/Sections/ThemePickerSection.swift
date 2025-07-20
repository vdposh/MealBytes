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
                Text("Automatic").tag(ThemeMode.automatic)
                Text("Dark").tag(ThemeMode.dark)
                Text("Light").tag(ThemeMode.light)
            }
            .pickerStyle(.navigationLink)
        } footer: {
            Text("Choose a theme to customize the app's appearance. The automatic mode follows system settings.")
        }
    }
}

#Preview {
    let loginViewModel = LoginViewModel()
    let mainViewModel = MainViewModel()
    let themeManager = ThemeManager()
    
    NavigationStack {
        ProfileView(
            profileViewModel: ProfileViewModel(
                loginViewModel: loginViewModel,
                mainViewModel: mainViewModel
            )
        )
        .environmentObject(themeManager)
    }
}
