//
//  IntakeToggleSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct IntakeToggleSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Section {
            Toggle("Daily Intake", isOn: $profileViewModel.displayIntake)
                .toggleStyle(SwitchToggleStyle(tint: .customGreen))
        } footer: {
            Text("Enable this option to display daily intake progress directly in the Diary.")
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
