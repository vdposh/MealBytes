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
            } footer: {
                VStack {
                    ActionButtonView(
                        title: "Login",
                        action: {
                            Task {
                                await loginViewModel.signIn()
                            }
                        },
                        isEnabled: loginViewModel.isLoginEnabled()
                    )
                    .padding(.top)
                    
                    VStack {
                        HStack(spacing: 4) {
                            Text("Don't have a MealBytes account?")
                            
                            NavigationLink("Sign up") {
                                RegisterView()
                            }
                            .fontWeight(.semibold)
                        }
                        .padding(.vertical, 8)
                        
                        HStack(spacing: 4) {
                            Text("Forgot the password?")
                            
                            NavigationLink("Reset") {
                                ResetView()
                            }
                            .fontWeight(.semibold)
                        }
                    }
                    .font(.footnote)
                    .padding(.horizontal)
                }
                .listRowInsets(.horizontal, 0)
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
