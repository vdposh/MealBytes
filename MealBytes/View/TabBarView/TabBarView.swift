//
//  TabBarView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 22/03/2025.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Int = 0
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var mainViewModel: MainViewModel
    @ObservedObject var goalsViewModel: GoalsViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Goals", systemImage: "chart.bar", value: 1) {
                NavigationStack {
                    GoalsView(goalsViewModel: goalsViewModel)
                }
            }
            
            Tab("Diary", systemImage: "fork.knife", value: 0) {
                NavigationStack {
                    MainView(mainViewModel: mainViewModel)
                }
            }
            
            Tab("Profile", systemImage: "person.fill", value: 2) {
                NavigationStack {
                    ProfileView(profileViewModel: profileViewModel)
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
        .overlay {
            FoodAddedAlertView(
                isVisible: $mainViewModel.isFoodAddedAlertVisible
            )
            .animation(
                .bouncy(duration: 0.3),
                value: mainViewModel.isFoodAddedAlertVisible
            )
        }
        .overlay {
            if profileViewModel.isLoading {
                LoadingProfileView()
            }
        }
        .alert(isPresented: $loginViewModel.showErrorAlert) {
            loginErrorAlert
        }
        .onChange(of: selectedTab) {
            mainViewModel.handleTabChange(to: selectedTab)
        }
    }
    
    private var loginErrorAlert: Alert {
        switch loginViewModel.alertType {
        case .sessionExpired:
            return loginViewModel.getSessionAlert {
                profileViewModel.signOut()
            }
            
        case .offlineMode:
            return loginViewModel.getOfflineAlert()
            
        case .generic:
            return loginViewModel.commonErrorAlert()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
