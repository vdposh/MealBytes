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
        if loginViewModel.isLoggedIn {
            TabBarView(loginViewModel: loginViewModel,
                       mainViewModel: mainViewModel)
        } else {
            LoginView(loginViewModel: loginViewModel)
                .task {
                    loginViewModel.setMainViewLoading = {
                        mainViewModel.isLoading = true
                    }
                }
        }
    }
}

#Preview {
    ContentView()
        .accentColor(.customGreen)
}
