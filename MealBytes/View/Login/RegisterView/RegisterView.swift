//
//  RegisterView.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var registerViewModel = RegisterViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Create account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                LoginTextFieldView(text: $registerViewModel.email,
                                   placeholder: "Email")
                
                LoginTextFieldView(text: $registerViewModel.password,
                                   placeholder: "Password",
                                   isSecureField: true)
                
                LoginTextFieldView(text: $registerViewModel.confirmPassword,
                                   placeholder: "Confirm Password",
                                   isSecureField: true)
                
                LoginButtonView(title: "Register", action: {
                    Task {
                        await registerViewModel.signUp()
                    }
                })
            }
            .padding()
            
            HStack {
                Text("Didn't receive the email?")
                    .font(.callout)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    Task {
                        await registerViewModel.resendEmailVerification()
                    }
                }) {
                    Text("Resend")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.customGreen)
                }
            }
            
            Text("To register, please provide a valid email address and create a password that is at least 6 characters long. After completing the registration form, an email will be sent to the provided address containing a verification link.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.vertical, 5)
            
            .alert(isPresented: $registerViewModel.showAlert) {
                registerViewModel.getAlert()
            }
        }
        .accentColor(.customGreen)
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
    .accentColor(.customGreen)
}
