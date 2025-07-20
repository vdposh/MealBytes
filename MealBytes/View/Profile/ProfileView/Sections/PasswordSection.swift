//
//  PasswordSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//


import SwiftUI

struct PasswordSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Section {
            Button {
                profileViewModel.prepareAlert(for: .changePassword)
            } label: {
                if profileViewModel.isPasswordChanging {
                    HStack {
                        LoadingView()
                        Text("Loading...")
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("Change Password")
                        .foregroundStyle(.customGreen)
                }
            }
            .disabled(profileViewModel.isPasswordChanging)
        } footer: {
            Text("Use this option to update the account password for improved security.")
                .padding(.bottom)
        }
    }
}

#Preview {
    let loginViewModel = LoginViewModel()
    let mainViewModel = MainViewModel()
    let themeManager = ThemeManager()
    
    NavigationStack {
        ProfileView(
            profileViewModel: ProfileViewModel(
                loginViewModel: loginViewModel,
                mainViewModel: mainViewModel
            )
        )
        .environmentObject(themeManager)
    }
}
