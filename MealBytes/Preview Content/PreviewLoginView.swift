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
        
        return NavigationStack {
            LoginView(loginViewModel: loginViewModel)
        }
    }
}

#Preview {
    PreviewLoginView.loginView
}
