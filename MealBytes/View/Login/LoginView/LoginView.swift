//
//  LoginView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/03/2025.
//

import SwiftUI

struct LoginView: View {
    @FocusState private var loginFocus: LoginField?
    @ObservedObject var loginViewModel: LoginViewModel
    
    var body: some View {
        loginViewContentBody
            .navigationTitle("Sign in")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                loginViewToolbar
            }
            .alert(isPresented: $loginViewModel.showAlert) {
                loginViewModel.getLoginErrorAlert()
            }
    }
    
    private var loginViewContentBody: some View {
        Form {
            Section {
                LoginTextFieldView(
                    text: $loginViewModel.email,
                    focus: $loginFocus,
                    focusCase: .email,
                    onSubmit: {
                        loginFocus = .password
                    }
                )
                
                SecureFieldView(
                    text: $loginViewModel.password,
                    focus: $loginFocus,
                    focusCase: .password,
                    onSubmit: {
                        Task {
                            await loginViewModel.signIn()
                        }
                    }
                )
            }
            
            Section {
                NavigationLink("Create Account") {
                    RegisterView()
                }
                
                NavigationLink("Forgot Password") {
                    ResetView()
                }
            }
        }
        .disabled(loginViewModel.isSignIn)
    }
    
    @ToolbarContentBuilder
    private var loginViewToolbar: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            if loginViewModel.isSignIn {
                ProgressView()
            } else {
                Button(role: .confirm) {
                    Task {
                        await loginViewModel.signIn()
                    }
                } label: {
                    Text("Login")
                        .fontWeight(.medium)
                        .foregroundStyle(.white)
                }
                .disabled(!loginViewModel.isLoginEnabled())
            }
        }
    }
    
    enum LoginField: Hashable {
        case email
        case password
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewLoginView.loginView
}
