//
//  PasswordView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 09/09/2025.
//

import SwiftUI

struct PasswordView: View {
    @FocusState private var passwordFocus: PasswordField?
    @StateObject private var passwordViewModel = PasswordViewModel()
    
    var body: some View {
        passwordViewContentBody
            .navigationTitle("Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                passwordViewToolbar
            }
            .alert(
                passwordViewModel.alertTitle,
                isPresented: passwordAlertBinding,
                actions: {
                    alertActions
                },
                message: {
                    Text(passwordViewModel.alertMessage)
                }
            )
            .task {
                passwordFocus = .currentPassword
            }
    }
    
    private var passwordViewContentBody: some View {
        Form {
            Section {
                SecureFieldView(
                    text: $passwordViewModel.currentPassword,
                    focus: $passwordFocus,
                    focusCase: .currentPassword,
                    placeholder: "Current Password"
                )
            }
            .disabled(passwordViewModel.isLoading)
            
            Section {
                SecureFieldView(
                    text: $passwordViewModel.newPassword,
                    focus: $passwordFocus,
                    focusCase: .newPassword,
                    placeholder: "New Password"
                )
                
                SecureFieldView(
                    text: $passwordViewModel.confirmPassword,
                    focus: $passwordFocus,
                    focusCase: .confirmPassword,
                    placeholder: "Confirm New Password"
                )
            } footer: {
                Text("Password must be at least 6 characters long.")
            }
            .disabled(passwordViewModel.isLoading)
        }
    }
    
    @ToolbarContentBuilder
    private var passwordViewToolbar: some ToolbarContent {
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
    
    private var passwordAlertBinding: Binding<Bool> {
        Binding(
            get: { passwordViewModel.showAlert },
            set: { newValue in
                if !newValue {
                    Task { @MainActor in
                        passwordViewModel.showAlert = false
                    }
                }
            }
        )
    }
    
    @ViewBuilder
    private var alertActions: some View {
        Button("OK") {
            if passwordViewModel.isSuccess {
                passwordViewModel.resetPasswordState()
            }
        }
    }
    
    enum PasswordField: Hashable {
        case currentPassword
        case newPassword
        case confirmPassword
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
