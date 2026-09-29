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
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Diary", systemImage: "book.closed.fill", value: .diary) {
                NavigationStack {
                    MainView(mainViewModel: mainViewModel)
                }
            }
            
            Tab("Settings", systemImage: "gear", value: .settings) {
                NavigationStack {
                    ProfileView(profileViewModel: profileViewModel)
                }
            }
        }
        .disabled(profileViewModel.isLoading)
        .alert(isPresented: $loginViewModel.showErrorAlert) {
            loginErrorAlert
        }
        .task {
            await profileViewModel.loadProfileData()
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
    case diary, settings, search
}

#Preview {
    PreviewContentView.contentView
}
