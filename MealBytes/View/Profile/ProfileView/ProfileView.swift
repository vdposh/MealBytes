//
//  ProfileView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/03/2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var profileViewModel: ProfileViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    init(loginViewModel: LoginViewModel,
         mainViewModel: MainViewModel) {
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(
            loginViewModel: loginViewModel,
            mainViewModel: mainViewModel)
        )
    }
    
    var body: some View {
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
                    Text("Account disconnected.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
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
                Text("Enable this option to display Recommended Daily Intake (RDI) in the Diary.")
            }
            
            Section {
                Picker("App Theme", selection: $themeManager.selectedTheme) {
                    Text("Automatic").tag(ThemeMode.automatic)
                    Text("Dark").tag(ThemeMode.dark)
                    Text("Light").tag(ThemeMode.light)
                }
                .pickerStyle(.navigationLink)
            } footer: {
                Text("Choose a theme to customize the app's appearance. The automatic mode follows system settings.")
            }
            
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
            
            Section {
                SignOutButtonView(
                    title: "Sign Out"
                ) {
                    profileViewModel.prepareAlert(for: .signOut)
                }
            } footer: {
                if profileViewModel.isDeletingAccount {
                    HStack {
                        ProgressView()
                    }
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
        .navigationBarTitle("Profile", displayMode: .inline)
        .task {
            await profileViewModel.loadProfileData()
        }
        .alert(
            profileViewModel.alertTitle,
            isPresented: $profileViewModel.showAlert,
            actions: {
                if profileViewModel.alertType == .deleteAccount {
                    SecureField("Enter password",
                                text: $profileViewModel.password)
                    .font(.callout)
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
                        
                        .font(.callout)
                        .textContentType(.password)
                        
                        SecureField("New Password",
                                    text: $profileViewModel.newPassword)
                        
                        .font(.callout)
                        .textContentType(.newPassword)
                        
                        SecureField("Confirm New Password",
                                    text: $profileViewModel.confirmPassword)
                        
                        .font(.callout)
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

#Preview {
    let loginViewModel = LoginViewModel()
    let mainViewModel = MainViewModel()
    let goalsViewModel = GoalsViewModel(mainViewModel: mainViewModel)
    
    ContentView(
        loginViewModel: loginViewModel,
        mainViewModel: mainViewModel,
        goalsViewModel: goalsViewModel
    )
    .environmentObject(ThemeManager())
}
