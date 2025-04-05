//
//  ProfileView.swift
//  MealBytes
//
//  Created by Porshe on 30/03/2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var profileViewModel: ProfileViewModel
    
    init(loginViewModel: LoginViewModel,
         mainViewModel: MainViewModel) {
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(
            loginViewModel: loginViewModel,
            mainViewModel: mainViewModel)
        )
    }
    
    var body: some View {
        ZStack {
            if !profileViewModel.isDataLoaded {
                LoadingView()
            } else {
                List {
                    Section {
                        if let email = profileViewModel.email {
                            VStack {
                                Text("This account is signed in:")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text(email)
                                    .font(.headline)
                                    .lineLimit(1)
                            }
                        } else {
                            Text("Unable to retrieve email.")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.customRed)
                        }
                    }
                    .padding(.bottom)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
                    
                    Section {
                        Toggle(
                            "Display RDI",
                            isOn: .init(
                                get: { profileViewModel
                                    .mainViewModel.shouldDisplayRdi },
                                set: { newValue in
                                    profileViewModel
                                        .updateShouldDisplayRdi(to: newValue)
                                }
                            )
                        )
                        .toggleStyle(SwitchToggleStyle(tint: .customGreen))
                    } footer: {
                        Text("Enable this option to display your Recommended Daily Intake (RDI) in the Diary.")
                    }
                    
                    Section {
                        Button(action: {
                            profileViewModel.prepareAlert(for: .changePassword)
                        }) {
                            Text("Change Password")
                        }
                    } footer: {
                        Text("Use this option to update your account password for improved security.")
                            .padding(.bottom)
                    }
                    
                    Section {
                        SignOutButtonView(
                            title: "Sign Out"
                        ) {
                            profileViewModel.prepareAlert(for: .signOut)
                        }
                    } footer: {
                        HStack(spacing: 4) {
                            Text("Do you want to")
                                .foregroundColor(.secondary)
                            
                            Button(action: {
                                profileViewModel.prepareAlert(
                                    for: .deleteAccount)
                            }) {
                                Text("remove")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.customRed)
                            }
                            .buttonStyle(.plain)
                            
                            Text("your account?")
                                .foregroundColor(.secondary)
                        }
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
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
                    SecureField("Enter your password",
                                text: $profileViewModel.password)
                    .textContentType(.password)
                    
                    Button(profileViewModel.destructiveButtonTitle,
                           role: .destructive) {
                        Task {
                            await profileViewModel.handleAlertAction()
                        }
                    }
                }
                if profileViewModel.alertType == .signOut {
                    Button(profileViewModel.destructiveButtonTitle,
                           role: .destructive) {
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
                        SecureField("Current Password",
                                    text: $profileViewModel.password)
                        .textContentType(.password)
                        
                        SecureField("New Password",
                                    text: $profileViewModel.newPassword)
                        .textContentType(.newPassword)
                        
                        Group {
                            Button("Cancel", role: .cancel) {
                                profileViewModel.showAlert = false
                            }
                            
                            Button(profileViewModel.destructiveButtonTitle) {
                                Task {
                                    await profileViewModel.handleAlertAction()
                                }
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
