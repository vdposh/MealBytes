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
            NavigationStack {
                GoalsView(goalsViewModel: goalsViewModel)
            }
            .tabItem {
                Image(systemName: "chart.bar")
                Text("Goals")
            }
            .tag(1)
            
            NavigationStack {
                MainView(mainViewModel: mainViewModel)
            }
            .tabItem {
                Image(systemName: "fork.knife")
                Text("Diary")
            }
            .tag(0)
            
            NavigationStack {
                ProfileView(profileViewModel: profileViewModel)
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(2)
        }
        .task {
            selectedTab = 0
        }
        .onChange(of: selectedTab) {
            mainViewModel.handleTabChange(to: selectedTab)
        }
        .alert(isPresented: $loginViewModel.showErrorAlert) {
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
        .overlay {
            if profileViewModel.isLoading {
                LoadingProfileView(
                    isLoading: $profileViewModel.isPasswordChanging
                )
            }
        }
        .overlay {
            FoodAlertOverlay(alertType: $mainViewModel.activeFoodAlert)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
