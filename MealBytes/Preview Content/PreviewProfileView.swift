//
//  PreviewProfileView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 05/09/2025.
//

import SwiftUI

struct PreviewProfileView {
    static var profileView: some View {
        let mainViewModel = MainViewModel()
        let dailyIntakeViewModel = DailyIntakeViewModel(
            mainViewModel: mainViewModel
        )
        let rdiViewModel = RdiViewModel(mainViewModel: mainViewModel)
        let goalsViewModel = GoalsViewModel(
            mainViewModel: mainViewModel,
            dailyIntakeViewModel: dailyIntakeViewModel,
            rdiViewModel: rdiViewModel
        )
        let loginViewModel = LoginViewModel(
            mainViewModel: mainViewModel,
            goalsViewModel: goalsViewModel
        )
        let themeManager = ThemeManager()
        
        return NavigationStack {
            ProfileView(
                profileViewModel: ProfileViewModel(
                    loginViewModel: loginViewModel,
                    mainViewModel: mainViewModel
                )
            )
            .environmentObject(themeManager)
        }
    }
}

#Preview {
    PreviewProfileView.profileView
}
