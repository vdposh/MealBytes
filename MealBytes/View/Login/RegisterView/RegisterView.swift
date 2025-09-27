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
            registerViewFooter
        }
        .alert(isPresented: $registerViewModel.showAlert) {
            registerViewModel.getAlert()
        }
    }
    
    private var registerViewContentBody: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Create account")
                .font(.title)
                .fontWeight(.bold)
            
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
            
            registerStateContent
        }
        .padding(.horizontal, 30)
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
    
    private var registerViewFooter: some View {
        Text("To register, provide a valid email address and create a password that is at least 6 characters long. Once done, you'll receive a verification email.")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 30)
            .padding(.top, 15)
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
