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
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            if  !profileViewModel.isDataLoaded {
                LoadingView()
            } else {
                VStack {
                    VStack {
                        if let email = profileViewModel.email {
                            VStack {
                                Text("This account is signed in:")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
                                
                                Text(email)
                                    .font(.headline)
                            }
                            .padding(.top)
                        } else {
                            Text("Unable to retrieve email.")
                                .font(.headline)
                                .foregroundColor(.customRed)
                        }
                        
                        Toggle(
                            "Display RDI",
                            isOn: Binding(
                                get: { profileViewModel
                                    .mainViewModel.shouldDisplayRdi },
                                set: { newValue in
                                    profileViewModel.mainViewModel
                                        .shouldDisplayRdi = newValue
                                    Task {
                                        await profileViewModel
                                            .saveDisplayRdiMainView(newValue)
                                    }
                                }
                            )
                        )
                        .toggleStyle(SwitchToggleStyle(tint: .customGreen))
                        .font(.headline)
                        .padding(.top, 50)
                        .padding(.horizontal, 35)
                        
                        Text("Enable this option to display your Recommended Daily Intake (RDI) in the app.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                        
                        Divider()
                            .padding(.horizontal, 30)
                    }
                    .padding(.top)
                    .frame(maxHeight: .infinity, alignment: .top)
                    
                    VStack {
                        RdiButtonView(
                            title: "Sign Out",
                            backgroundColor: .customRed
                        ) {
                            profileViewModel.prepareAlert(for: .signOut)
                        }
                        
                        HStack(spacing: 4) {
                            Text("Do you want to")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            
                            Button(action: {
                                profileViewModel.prepareAlert(
                                    for: .deleteAccount)
                            }) {
                                Text("remove")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.customRed)
                            }
                            
                            Text("your account?")
                                .foregroundColor(.secondary)
                        }
                        .font(.footnote)
                        .padding(.top)
                        .padding(.bottom, 50)
                    }
                }
            }
        }
        .task {
            await profileViewModel.mainViewModel.loadDisplayRdiMainView()
            await profileViewModel.fetchCurrentUserEmail()
        }
        
        .alert(
            profileViewModel.alertTitle,
            isPresented: $profileViewModel.showAlert,
            actions: {
                Button(profileViewModel.destructiveButtonTitle,
                       role: .destructive) {
                    profileViewModel.handleAlertAction()
                }
                Button("Cancel", role: .cancel) { }
            },
            message: {
                Text(profileViewModel.alertMessage)
            }
        )
    }
}

#Preview {
    ContentView()
        .accentColor(.customGreen)
}

//#Preview {
//    NavigationStack {
//        ProfileView(loginViewModel: LoginViewModel(),
//                    mainViewModel: MainViewModel())
//    }
//    .accentColor(.customGreen)
//}
