//
//  AccountView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/09/2026.
//

import SwiftUI

struct AccountView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Form {
            credentialsSection
            actionsSection
        }
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            profileViewModel.alertTitle,
            isPresented: Binding(
                get: { profileViewModel.showAlert },
                set: { newValue in
                    if !newValue {
                        Task { @MainActor in
                            profileViewModel.showAlert = false
                            profileViewModel.alertContent = nil
                        }
                    }
                }
            ),
            actions: {
                alertActions
            },
            message: {
                Text(profileViewModel.alertMessage)
            }
        )
    }
    
    private var credentialsSection: some View {
        Section {
            NavigationLink {
                EmailView(currentEmail: profileViewModel.email ?? "")
            } label: {
                LabeledContent {
                    Text(profileViewModel.email ?? "")
                } label: {
                    Text("Email")
                }
            }
            
            NavigationLink {
                PasswordView()
            } label: {
                LabeledContent {
                    Text("••••••••")
                } label: {
                    Text("Password")
                }
            }
        }
    }
    
    private var actionsSection: some View {
        Section {
            Button(role: .destructive) {
                profileViewModel.prepareAlert(for: .signOut)
            } label: {
                Text("Sign Out")
            }
            
            Button(role: .destructive) {
                profileViewModel.prepareAlert(for: .deleteAccount)
            } label: {
                Text("Delete Account")
            }
        }
    }
    
    @ViewBuilder
    private var alertActions: some View {
        switch profileViewModel.alertContent?.type {
        case .deleteAccount:
            TextField(
                "Enter \"Delete\" to confirm",
                text: $profileViewModel.deleteConfirmationText
            )
            .autocorrectionDisabled()
            
            Button(profileViewModel.destructiveTitle, role: .destructive) {
                Task {
                    await profileViewModel.handleProfileAlertAction()
                }
            }
            .disabled(!profileViewModel.isDeleteConfirmed)
            
            Button(role: .cancel) { }
            
        case .signOut:
            Button(profileViewModel.destructiveTitle, role: .destructive) {
                Task {
                    await profileViewModel.handleProfileAlertAction()
                }
            }
            
            Button(role: .cancel) { }
            
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
