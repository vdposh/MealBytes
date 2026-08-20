//
//  TabBarView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 22/03/2025.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Tabs = .diary
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var mainViewModel: MainViewModel
    @ObservedObject var goalsViewModel: GoalsViewModel
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Goals", systemImage: "chart.bar", value: .goals) {
                NavigationStack {
                    GoalsView(goalsViewModel: goalsViewModel)
                }
            }
            
            Tab("Diary", systemImage: "fork.knife", value: .diary) {
                NavigationStack {
                    MainView(mainViewModel: mainViewModel)
                }
            }
            
            Tab("Profile", systemImage: "person.fill", value: .profile) {
                NavigationStack {
                    ProfileView(profileViewModel: profileViewModel)
                }
            }
        }
        .disabled(profileViewModel.isLoading)
        .alert(isPresented: $loginViewModel.showErrorAlert) {
            loginErrorAlert
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

enum Tabs {
    case diary, goals, profile, search
}

#Preview {
    PreviewContentView.contentView
}
