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
        let loginViewModel = LoginViewModel(mainViewModel: mainViewModel)
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
