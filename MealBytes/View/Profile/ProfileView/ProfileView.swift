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
        List {
            AccountInfoSection(profileViewModel: profileViewModel)
            IntakeToggleSection(profileViewModel: profileViewModel)
            ThemePickerSection()
            PasswordSection(profileViewModel: profileViewModel)
            SignOutSection(profileViewModel: profileViewModel)
        }
        .navigationBarTitle("Profile", displayMode: .inline)
        .task {
            await profileViewModel.loadProfileData()
        }
        .alert(
            profileViewModel.alertTitle,
            isPresented: $profileViewModel.showAlert,
            actions: {
                if profileViewModel.alertType == .deleteAccount {
                    SecureField(
                        "Enter password",
                        text: $profileViewModel.password
                    )
                    .font(.callout)
                    .textContentType(.password)
                    
                    Button(
                        profileViewModel.destructiveButtonTitle,
                        role: .destructive
                    ) {
                        Task {
                            await profileViewModel.handleAlertAction()
                        }
                    }
                }
                
                if profileViewModel.alertType == .signOut {
                    Button(
                        profileViewModel.destructiveButtonTitle,
                        role: .destructive
                    ) {
                        Task {
                            await profileViewModel.handleAlertAction()
                        }
                    }
                }
                
                if profileViewModel.alertType == .changePassword {
                    if profileViewModel.alertTitle == "Done" {
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
                        
                        Button(
                            profileViewModel.destructiveButtonTitle
                        ) {
                            Task {
                                await profileViewModel.handleAlertAction()
                            }
                        }
                    }
                }
            },
            message: {
                Text(profileViewModel.alertMessage)
            }
        )
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    let mainViewModel = MainViewModel()
    let dailyIntakeViewModel = DailyIntakeViewModel(
        mainViewModel: mainViewModel
    )
    let rdiViewModel = RdiViewModel(
        mainViewModel: mainViewModel
    )
    let goalsViewModel = GoalsViewModel(
        mainViewModel: mainViewModel,
        dailyIntakeViewModel: dailyIntakeViewModel,
        rdiViewModel: rdiViewModel
    )
    let loginViewModel = LoginViewModel(
        mainViewModel: mainViewModel,
        goalsViewModel: goalsViewModel
    )
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
