//
//  PreviewContentView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 15/07/2025.
//

import SwiftUI

struct PreviewContentView {
    static var contentView: some View {
        let mainViewModel = MainViewModel()
        let macrosIntakeViewModel:
        MacrosIntakeViewModelProtocol = MacrosIntakeViewModel(
            mainViewModel: mainViewModel
        )
        let personalIntakeViewModel:
        PersonalIntakeViewModelProtocol = PersonalIntakeViewModel(
            mainViewModel: mainViewModel
        )
        let customIntakeViewModel = CustomIntakeViewModel(
            mainViewModel: mainViewModel
        )
        let goalsViewModel = GoalsViewModel(
            mainViewModel: mainViewModel,
            macrosIntakeViewModel: macrosIntakeViewModel,
            personalIntakeViewModel: personalIntakeViewModel,
            customIntakeViewModel: customIntakeViewModel
        )
        let loginViewModel = LoginViewModel(
            mainViewModel: mainViewModel,
            goalsViewModel: goalsViewModel
        )
        let profileViewModel = ProfileViewModel(
            loginViewModel: loginViewModel,
            mainViewModel: mainViewModel
        )
        let themeManager = ThemeManager()
        
        return ContentView(
            loginViewModel: loginViewModel,
            mainViewModel: mainViewModel,
            goalsViewModel: goalsViewModel,
            profileViewModel: profileViewModel
        )
        .environmentObject(themeManager)
    }
}

#Preview {
    PreviewContentView.contentView
}
