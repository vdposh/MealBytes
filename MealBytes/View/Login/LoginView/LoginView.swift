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
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                LoginTextFieldView(text: $loginViewModel.email,
                                   placeholder: "Email")
                
                LoginTextFieldView(text: $loginViewModel.password,
                                   placeholder: "Password",
                                   isSecureField: true)
                
                LoginButtonView(title: "Login", action: {
                    Task {
                        await loginViewModel.signIn()
                    }
                })
            }
            .padding()
            
            VStack(spacing: 10) {
                HStack {
                    Text("Don't have a MealBytes account?")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        loginViewModel.navigationDestination = .registerView
                    }) {
                        Text("Sign up")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.customGreen)
                    }
                }
                
                HStack {
                    Text("Forgot the password?")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        loginViewModel.navigationDestination = .resetView
                    }) {
                        Text("Reset")
                            .font(.callout)
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
