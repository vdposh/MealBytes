//
//  ContentView.swift
//  MealBytes
//
//  Created by Porshe on 30/03/2025.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    @StateObject private var mainViewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            if loginViewModel.isLoading {
                LoginLoadingView()
            } else if loginViewModel.isLoggedIn {
                TabBarView(loginViewModel: loginViewModel,
                           mainViewModel: mainViewModel)
            } else {
                LoginView(loginViewModel: loginViewModel)
            }
            
            if loginViewModel.isLoggedIn && mainViewModel.isLoading {
                LoginLoadingView()
            }
        }
    }
}
