//
//  SignOutSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//


import SwiftUI

struct SignOutSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Section {
            SignOutButtonView(title: "Sign Out") {
                profileViewModel.prepareAlert(for: .signOut)
            }
        } footer: {
            if profileViewModel.isDeletingAccount {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            } else {
                HStack(spacing: 4) {
                    Text("Do you want to")
                        .foregroundColor(.secondary)
                    
                    Button {
                        profileViewModel.prepareAlert(for: .deleteAccount)
                    } label: {
                        Text("delete")
                            .fontWeight(.semibold)
                            .foregroundColor(.customRed)
                    }
                    .buttonStyle(.plain)
                    
                    Text("the account?")
                        .foregroundColor(.secondary)
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            }
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
