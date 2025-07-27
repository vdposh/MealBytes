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
            VStack(alignment: .leading, spacing: 20) {
                Text("Sign in")
                    .font(.title)
                    .fontWeight(.bold)
                
                LoginTextFieldView(
                    text: $loginViewModel.email,
                    titleColor: loginViewModel.titleColor(
                        for: loginViewModel.email
                    )
                )
                
                SecureFieldView(
                    text: $loginViewModel.password,
                    title: "Password",
                    placeholder: "Enter password",
                    titleColor: loginViewModel.titleColor(
                        for: loginViewModel.password
                    )
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
                .frame(height: 50)
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            
            VStack(spacing: 10) {
                HStack(spacing: 4) {
                    Text("Don't have a MealBytes account?")
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("Sign up")
                            .fontWeight(.semibold)
                    }
                }
                
                HStack(spacing: 4) {
                    Text("Forgot the password?")
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: ResetView()) {
                        Text("Reset")
                            .fontWeight(.semibold)
                    }
                }
            }
            .font(.footnote)
            .alert(isPresented: $loginViewModel.showAlert) {
                loginViewModel.getLoginErrorAlert()
            }
        }
    }
}

#Preview {
    NavigationStack {
        LoginView(
            loginViewModel: LoginViewModel(mainViewModel: MainViewModel())
        )
    }
}
