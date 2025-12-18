//
//  LoginView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/03/2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var loginViewModel: LoginViewModel
    
    var body: some View {
        NavigationStack {
            loginViewContentBody
            loginViewFooter
        }
        .alert(isPresented: $loginViewModel.showAlert) {
            loginViewModel.getLoginErrorAlert()
        }
    }
    
    private var loginViewContentBody: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Sign in")
                .font(.title)
                .fontWeight(.bold)
            
            LoginTextFieldView(
                text: $loginViewModel.email
            )
            
            SecureFieldView(
                text: $loginViewModel.password
            )
            
            ActionButtonView(
                title: "Login",
                action: {
                    Task {
                        await loginViewModel.signIn()
                    }
                },
                isEnabled: loginViewModel.isLoginEnabled()
            )
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 15)
    }
    
    private var loginViewFooter: some View {
        VStack(spacing: 10) {
            HStack(spacing: 5) {
                Text("Don't have a MealBytes account?")
                    .foregroundStyle(.secondary)
                
                NavigationLink("Sign up") {
                    RegisterView()
                }
                .fontWeight(.semibold)
            }
            
            HStack(spacing: 5) {
                Text("Forgot the password?")
                    .foregroundStyle(.secondary)
                
                NavigationLink("Reset") {
                    ResetView()
                }
                .fontWeight(.semibold)
            }
        }
        .font(.footnote)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewLoginView.loginView
}
