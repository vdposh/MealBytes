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
            if loginViewModel.isLoading || mainViewModel.isLoading {
                LoginLoadingView()
            } else if loginViewModel.isLoggedIn {
                TabBarView(loginViewModel: loginViewModel,
                           mainViewModel: mainViewModel)
            } else {
                LoginView(loginViewModel: loginViewModel)
            }
        }
        .task {
            await mainViewModel.loadMainData()
        }
    }
}
