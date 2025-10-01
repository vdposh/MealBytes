//
//  ProfileView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/03/2025.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        profileViewContentBody
            .navigationBarTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert(
                profileViewModel.alertTitle,
                isPresented: $profileViewModel.showAlert,
                actions: { alertActions },
                message: { Text(profileViewModel.alertMessage) }
            )
            .task {
                await profileViewModel.loadProfileData()
            }
    }
    
    private var profileViewContentBody: some View {
        Form {
            AccountInfoSection(profileViewModel: profileViewModel)
            IntakeToggleSection(profileViewModel: profileViewModel)
            ThemePickerSection()
            PasswordSection(profileViewModel: profileViewModel)
            SignOutSection(profileViewModel: profileViewModel)
        }
        .id(profileViewModel.uniqueId)
    }
    
    @ViewBuilder
    private var alertActions: some View {
        switch profileViewModel.alertContent?.type {
        case .deleteAccount:
            SecureField(
                "Current Password",
                text: $profileViewModel.password
            )
            .font(.callout)
            .textContentType(.password)
            
            Button(profileViewModel.destructiveTitle, role: .destructive) {
                Task {
                    await profileViewModel.handleAlertAction()
                }
            }
            
        case .signOut:
            Button(profileViewModel.destructiveTitle, role: .destructive) {
                Task {
                    await profileViewModel.handleAlertAction()
                }
            }
            
        case .changePassword:
            if profileViewModel.alertContent?.isSuccess == true {
                Button("OK") {
                    profileViewModel.showAlert = false
                }
            } else {
                SecureField(
                    "Current Password",
                    text: $profileViewModel.password
                )
                .font(.callout)
                .textContentType(.password)
                
                SecureField(
                    "New Password",
                    text: $profileViewModel.newPassword
                )
                .font(.callout)
                .textContentType(.newPassword)
                
                SecureField(
                    "Confirm New Password",
                    text: $profileViewModel.confirmPassword
                )
                .font(.callout)
                .textContentType(.newPassword)
                
                Button("Cancel", role: .cancel) {
                    profileViewModel.showAlert = false
                }
                
                Button(profileViewModel.destructiveTitle) {
                    Task {
                        await profileViewModel.handleAlertAction()
                    }
                }
            }
            
        default:
            EmptyView()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewProfileView.profileView
}
