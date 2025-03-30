//
//  LoginView.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var loginViewModel = LoginViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Sign in")
                    .font(.title)
                    .fontWeight(.bold)
                
                ServingTextFieldView(
                    text: $loginViewModel.email,
                    title: "Email",
                    placeholder: "Enter your email",
                    keyboardType: .emailAddress,
                    titleColor: loginViewModel.titleColor(
                        for: loginViewModel.email)
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                ServingSecureFieldView(
                    text: $loginViewModel.password,
                    title: "Password",
                    placeholder: "Enter your password",
                    titleColor: loginViewModel.titleColor(
                        for: loginViewModel.password)
                )
                
                ActionButtonView(
                    title: "Login",
                    action: {
                        Task {
                            await loginViewModel.signIn()
                        }
                    },
                    backgroundColor: .customGreen,
                    isEnabled: loginViewModel.isLoginEnabled()
                )
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            
            VStack(spacing: 10) {
                HStack {
                    Text("Don't have a MealBytes account?")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        loginViewModel.navigationDestination = .registerView
                    }) {
                        Text("Sign up")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.customGreen)
                    }
                }
                
                HStack {
                    Text("Forgot the password?")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        loginViewModel.navigationDestination = .resetView
                    }) {
                        Text("Reset")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(.customGreen)
                    }
                }
            }
            
            .alert(isPresented: $loginViewModel.showAlert) {
                loginViewModel.getAlert()
            }
            .navigationDestination(isPresented: Binding(
                get: { loginViewModel.navigationDestination != .none },
                set: { if !$0 { loginViewModel.navigationDestination = .none } }
            )) {
                switch loginViewModel.navigationDestination {
                case .registerView:
                    loginViewModel.registerView
                case .resetView:
                    loginViewModel.resetView
                case .none:
                    EmptyView()
                }
            }
        }
        .accentColor(.customGreen)
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
    .accentColor(.customGreen)
}
