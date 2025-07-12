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
    
    var body: some View {
        ZStack {
            if loginViewModel.isSignIn {
                LoginLoadingView()
            } else if loginViewModel.isLoading {
                LoginLogoView()
            } else if loginViewModel.isLoggedIn {
                TabBarView(
                    loginViewModel: loginViewModel,
                    mainViewModel: mainViewModel,
                    goalsViewModel: goalsViewModel
                )
            } else {
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
    let loginViewModel = LoginViewModel()
    let mainViewModel = MainViewModel()
    let goalsViewModel = GoalsViewModel(mainViewModel: mainViewModel)

    ContentView(
        loginViewModel: loginViewModel,
        mainViewModel: mainViewModel,
        goalsViewModel: goalsViewModel
    )
    .environmentObject(ThemeManager())
}
