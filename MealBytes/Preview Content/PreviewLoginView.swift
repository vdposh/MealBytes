//
//  PreviewLoginView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/09/2025.
//

import SwiftUI

struct PreviewLoginView {
    static var loginView: some View {
        let mainViewModel = MainViewModel()
        let macrosIntakeViewModel = MacrosIntakeViewModel(
            mainViewModel: mainViewModel
        )
        let personalIntakeViewModel = PersonalIntakeViewModel(
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
        let themeManager = ThemeManager()
        
        return NavigationStack {
            LoginView(loginViewModel: loginViewModel)
                .environmentObject(themeManager)
        }
    }
}

#Preview {
    PreviewLoginView.loginView
}
