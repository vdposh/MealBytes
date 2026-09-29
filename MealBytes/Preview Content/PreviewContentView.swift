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
        let loginViewModel = LoginViewModel(mainViewModel: mainViewModel)
        let profileViewModel = ProfileViewModel(
            loginViewModel: loginViewModel,
            mainViewModel: mainViewModel
        )
        let themeManager = ThemeManager()
        
        return ContentView(
            loginViewModel: loginViewModel,
            mainViewModel: mainViewModel,
            profileViewModel: profileViewModel
        )
        .environmentObject(themeManager)
    }
}

#Preview {
    PreviewContentView.contentView
}
