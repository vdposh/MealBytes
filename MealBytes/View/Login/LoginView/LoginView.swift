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
            
            VStack(spacing: 15) {
                HStack {
                    Text("Don't have a MealBytes account?")
                        .font(.callout)
                        .foregroundColor(.secondary)
                    
                    NavigationLink(destination: loginViewModel.registerView) {
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
                    
                    NavigationLink(destination: loginViewModel.resetView) {
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
