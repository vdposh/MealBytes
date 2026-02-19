//
//  LoginView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/03/2025.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var themeManager: ThemeManager
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
            } footer: {
                VStack(spacing: 20) {
                    ActionButtonView(
                        title: "Login",
                        action: {
                            Task {
                                await loginViewModel.signIn()
                            }
                        },
                        isEnabled: loginViewModel.isLoginEnabled()
                    )
                    
                    VStack(spacing: 10) {
                        HStack(spacing: 5) {
                            Text("Don't have a MealBytes account?")
                            
                            NavigationLink("Sign up") {
                                RegisterView()
                            }
                            .fontWeight(.semibold)
                        }
                        
                        HStack(spacing: 5) {
                            Text("Forgot the password?")
                            
                            NavigationLink("Reset") {
                                ResetView()
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
    
    @ToolbarContentBuilder
    private var loginViewToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker("App Theme", selection: $themeManager.selectedTheme) {
                    ForEach(ThemeMode.allCases, id: \.self) { theme in
                        Label(
                            theme.rawValue.capitalized,
                            systemImage: theme.iconName
                        )
                        .tag(theme)
                    }
                }
                
                Text("Automatic setting follows system")
            } label: {
                Image(systemName: themeManager.selectedTheme.iconName)
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
