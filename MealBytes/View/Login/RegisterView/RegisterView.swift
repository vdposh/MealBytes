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
        NavigationStack {
            registerViewContentBody
                .navigationTitle("Create account")
                .navigationBarTitleDisplayMode(.inline)
        }
        .alert(isPresented: $registerViewModel.showAlert) {
            registerViewModel.getAlert()
        }
    }
    
    private var registerViewContentBody: some View {
        Form {
            Section {
                LoginTextFieldView(
                    text: $registerViewModel.email
                )
                .textContentType(.emailAddress)
                
                SecureFieldView(
                    text: $registerViewModel.password
                )
                
                SecureFieldView(
                    text: $registerViewModel.confirmPassword,
                    placeholder: "Re-enter Password"
                )
            } footer: {
                VStack(spacing: 20) {
                    registerStateContent
                    
                    Text("To register, provide a valid email address and create a password that is at least 6 characters long. Once done, you'll receive a verification email.")
                }
                .padding(.vertical)
            }
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private var registerStateContent: some View {
        switch registerViewModel.registerState {
        case .loading:
            LoadingView(showFrame: true)
            
        case .resend:
            if registerViewModel.showResendOptions {
                ResendEmailView(registerViewModel: registerViewModel)
            }
            
        case .register:
            ActionButtonView(
                title: "Register",
                action: {
                    Task {
                        await registerViewModel.signUp()
                    }
                },
                isEnabled: registerViewModel.isRegisterEnabled()
            )
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    RegisterView()
}

#Preview {
    PreviewLoginView.loginView
}
