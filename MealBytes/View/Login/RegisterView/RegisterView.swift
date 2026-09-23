//
//  RegisterView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/03/2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var registerViewModel = RegisterViewModel()
    
    var body: some View {
        registerViewContentBody
            .navigationTitle("Create account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                registerViewToolbar
            }
            .alert(isPresented: $registerViewModel.showAlert) {
                registerViewModel.getAlert()
            }
    }
    
    private var registerViewContentBody: some View {
        Form {
            Section {
                LoginTextFieldView(text: $registerViewModel.email)
                    .textContentType(.emailAddress)
                
                SecureFieldView(
                    text: $registerViewModel.password
                )
                
                SecureFieldView(
                    text: $registerViewModel.confirmPassword,
                    placeholder: "Confirm Password"
                )
            } footer: {
                Text("Enter email and create a password (min 6 characters). A verification email will be sent.")
            }
        }
    }
    
    @ToolbarContentBuilder
    private var registerViewToolbar: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            switch registerViewModel.registerState {
            case .loading:
                ProgressView()
                
            case .resend:
                if registerViewModel.isResendEnabled {
                    Button(role: .confirm) {
                        Task {
                            await registerViewModel.resendEmailVerification()
                        }
                    } label: {
                        Text("Resend")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                    .disabled(registerViewModel.isRegisterLoading)
                } else {
                    Text(registerViewModel.timerText)
                        .fontWeight(.semibold)
                        .frame(width: 65)
                }
                
            case .register:
                Button(role: .confirm) {
                    Task {
                        await registerViewModel.signUp()
                    }
                }
                .disabled(!registerViewModel.isRegisterEnabled())
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}

#Preview {
    PreviewLoginView.loginView
}
