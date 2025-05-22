//
//  ContentView.swift
//  MealBytes
//
//  Created by Porshe on 30/03/2025.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        ZStack {
            if loginViewModel.isSignIn {
                LoginLoadingView()
            } else if loginViewModel.isLoading {
                LoginLogoView()
            } else if loginViewModel.isLoggedIn {
                TabBarView(loginViewModel: loginViewModel,
                           mainViewModel: mainViewModel)
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
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel()
    )
}
