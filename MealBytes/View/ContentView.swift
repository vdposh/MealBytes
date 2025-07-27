//
//  ContentView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/03/2025.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var mainViewModel: MainViewModel
    @ObservedObject var goalsViewModel: GoalsViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            switch loginViewModel.loginState {
            case .signingIn:
                LoginLoadingView()
            case .loadingLogo:
                LoginLogoView()
            case .loggedIn:
                TabBarView(
                    loginViewModel: loginViewModel,
                    mainViewModel: mainViewModel,
                    goalsViewModel: goalsViewModel,
                    profileViewModel: profileViewModel
                )
            case .notLoggedIn:
                LoginView(loginViewModel: loginViewModel)
            }
        }
        .task {
            await mainViewModel.loadMainData()
            await loginViewModel.loadLoginData()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
