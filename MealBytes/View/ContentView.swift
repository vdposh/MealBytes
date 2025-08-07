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
        ZStack(alignment: .bottom) {
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
            
#if DEBUG
            VStack {
                SystemStatsView()
                    .background(.ultraThickMaterial.opacity(0.8))
                    .cornerRadius(12)
            }
            .allowsHitTesting(false)
#endif
            
        }
        .task {
            await loginViewModel.loadData()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
