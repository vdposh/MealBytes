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
        let dailyIntakeViewModel:
        DailyIntakeViewModelProtocol = DailyIntakeViewModel(
            mainViewModel: mainViewModel
        )
        let rdiViewModel: RdiViewModelProtocol = RdiViewModel(
            mainViewModel: mainViewModel
        )
        let goalsViewModel = GoalsViewModel(
            mainViewModel: mainViewModel,
            dailyIntakeViewModel: dailyIntakeViewModel,
            rdiViewModel: rdiViewModel
        )
        let loginViewModel = LoginViewModel(
            mainViewModel: mainViewModel,
            goalsViewModel: goalsViewModel
        )
        let profileViewModel = ProfileViewModel(
            loginViewModel: loginViewModel,
            mainViewModel: mainViewModel
        )
        let searchViewModel = SearchViewModel(
            mainViewModel: mainViewModel)
        
        let themeManager = ThemeManager()
        
        return ContentView(
            loginViewModel: loginViewModel,
            mainViewModel: mainViewModel,
            goalsViewModel: goalsViewModel,
            profileViewModel: profileViewModel,
            searchViewModel: searchViewModel
        )
        .environmentObject(themeManager)
    }
}

#Preview {
    PreviewContentView.contentView
}
