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
                    text: $loginViewModel.email
                )
                
                SecureFieldView(
                    text: $loginViewModel.password
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
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }
                .disabled(!loginViewModel.isLoginEnabled())
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewLoginView.loginView
}
