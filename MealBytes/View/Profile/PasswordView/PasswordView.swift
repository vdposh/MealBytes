//
//  PasswordView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 09/09/2025.
//

import SwiftUI

struct PasswordView: View {
    @StateObject private var passwordViewModel = PasswordViewModel()
    
    var body: some View {
        Form {
            Section {
                SecureFieldView(
                    text: $passwordViewModel.currentPassword,
                    placeholder: "Current Password",
                    showLabel: false
                )
            }
            .disabled(passwordViewModel.isLoading)
            
            Section {
                SecureFieldView(
                    text: $passwordViewModel.newPassword,
                    placeholder: "New Password",
                    showLabel: false
                )
                
                SecureFieldView(
                    text: $passwordViewModel.confirmPassword,
                    placeholder: "Confirm New Password",
                    showLabel: false
                )
            }
            .disabled(passwordViewModel.isLoading)
        }
        .navigationTitle("Change Password")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if passwordViewModel.isLoading {
                    ProgressView()
                } else {
                    Button(role: .confirm) {
                        Task {
                            await passwordViewModel.changePassword()
                        }
                    }
                    .disabled(!passwordViewModel.isFormValid)
                }
            }
        }
        .alert(
            passwordViewModel.alertTitle,
            isPresented: $passwordViewModel.showAlert,
            actions: {
                Button("OK") {
                    if passwordViewModel.isSuccess {
                        passwordViewModel.resetPasswordState()
                    } else {
                        passwordViewModel.showAlert = false
                    }
                }
            },
            message: {
                Text(passwordViewModel.alertMessage)
            }
        )
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewProfileView.profileView
}

#Preview {
    NavigationStack {
        PasswordView()
    }
}
