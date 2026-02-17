//
//  LoginView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/03/2025.
//

import SwiftUI

struct LoginView: View {
    @FocusState private var focus: LoginFocus?
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
            .focused($focus, equals: .email)
            
            SecureFieldView(
                text: $loginViewModel.password
            )
            .focused($focus, equals: .password)
            
            ActionButtonView(
                title: "Login",
                action: {
                    focus = nil
                    
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
                .task {
                    focus = nil
                }
                .fontWeight(.semibold)
            }
            
            HStack(spacing: 5) {
                Text("Forgot the password?")
                    .foregroundStyle(.secondary)
                
                NavigationLink("Reset") {
                    ResetView()
                }
                .task {
                    focus = nil
                }
                .fontWeight(.semibold)
            }
        }
        .font(.footnote)
    }
    
    enum LoginFocus {
        case email, password
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewLoginView.loginView
}
