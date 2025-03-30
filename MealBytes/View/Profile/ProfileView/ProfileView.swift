//
//  ProfileView.swift
//  MealBytes
//
//  Created by Porshe on 30/03/2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var profileViewModel: ProfileViewModel
    
    init(loginViewModel: LoginViewModel) {
        _profileViewModel = StateObject(
            wrappedValue: ProfileViewModel(loginViewModel: loginViewModel)
        )
    }
    
    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
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
                    } else {
                        Text("Unable to retrieve email.")
                            .font(.headline)
                            .foregroundColor(.customRed)
                    }
                }
                .padding(.vertical)
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
                            profileViewModel.prepareAlert(for: .deleteAccount)
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
            .navigationBarTitle("Your Profile", displayMode: .inline)
            .task {
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
}

#Preview {
    ContentView()
        .accentColor(.customGreen)
}
