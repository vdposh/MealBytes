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
    @ObservedObject var searchViewModel: SearchViewModel
    
    var body: some View {
        tabBarViewContentBody
            .overlay {
                FoodAlertView(
                    isVisible: $mainViewModel.isFoodAddedAlertVisible
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
    
    private var tabBarViewContentBody: some View {
        TabView(selection: $selectedTab) {
            Tab(value: 1) {
                NavigationStack {
                    GoalsView(goalsViewModel: goalsViewModel)
                }
            } label: {
                Label("Goals", systemImage: "chart.bar")
            }
            
            Tab(value: 0) {
                NavigationStack {
                    MainView(mainViewModel: mainViewModel)
                }
            } label: {
                Label("Diary", systemImage: "fork.knife")
            }
            
            Tab(value: 2) {
                NavigationStack {
                    ProfileView(profileViewModel: profileViewModel)
                }
            } label: {
                Label("Profile", systemImage: "person.fill")
            }
            
            Tab(value: 3, role: .search) {
                NavigationStack {
                    SearchView(
                        searchViewModel: searchViewModel,
                        mealType: .breakfast
                    )
                }
            }
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
