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
                    placeholder: "Current Password"
                )
            }
            .disabled(passwordViewModel.isLoading)
            
            Section {
                SecureFieldView(
                    text: $passwordViewModel.newPassword,
                    placeholder: "New Password"
                )
                
                SecureFieldView(
                    text: $passwordViewModel.confirmPassword,
                    placeholder: "Confirm New Password"
                )
            } footer: {
                Text("Password must be at least 6 characters long.")
            }
            .disabled(passwordViewModel.isLoading)
        }
        .navigationTitle("Password")
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
            isPresented: Binding(
                get: { passwordViewModel.showAlert },
                set: { newValue in
                    if !newValue {
                        Task { @MainActor in
                            passwordViewModel.showAlert = false
                        }
                    }
                }
            ),
            actions: {
                Button("OK") {
                    Task {
                        if passwordViewModel.isSuccess {
                            await passwordViewModel.resetPasswordState()
                        }
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
