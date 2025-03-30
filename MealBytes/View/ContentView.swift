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
    
    var body: some View {
        if loginViewModel.isLoggedIn {
            TabBarView()
        } else {
            LoginView(loginViewModel: loginViewModel)
        }
    }
}
