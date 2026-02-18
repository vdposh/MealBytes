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
                .navigationTitle("Sign in")
                .navigationBarTitleDisplayMode(.inline)
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
                .focused($focus, equals: .email)
                
                SecureFieldView(
                    text: $loginViewModel.password
                )
                .focused($focus, equals: .password)
            } footer: {
                VStack(spacing: 20) {
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
                    
                    VStack(spacing: 15) {
                        HStack(spacing: 5) {
                            Text("Don't have a MealBytes account?")
                            
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
                .padding(.vertical)
            }
        }
        .scrollIndicators(.hidden)
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
