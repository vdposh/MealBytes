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
        let loginViewModel = LoginViewModel(mainViewModel: mainViewModel)
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
