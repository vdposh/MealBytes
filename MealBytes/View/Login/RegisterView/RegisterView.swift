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
                    .font(.title)
                    .fontWeight(.bold)
                
                ServingTextFieldView(
                    text: $registerViewModel.email,
                    title: "Email",
                    placeholder: "Enter your email",
                    keyboardType: .emailAddress,
                    titleColor: registerViewModel.titleColor(
                        for: registerViewModel.email)
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                ServingSecureFieldView(
                    text: $registerViewModel.password,
                    title: "Password",
                    placeholder: "Enter your password",
                    titleColor: registerViewModel.titleColor(
                        for: registerViewModel.password)
                )
                
                ServingSecureFieldView(
                    text: $registerViewModel.confirmPassword,
                    title: "Confirm Password",
                    placeholder: "Re-enter your password",
                    titleColor: registerViewModel.titleColor(
                        for: registerViewModel.confirmPassword)
                )
                
                ActionButtonView(
                    title: "Register",
                    action: {
                        Task {
                            await registerViewModel.signUp()
                        }
                    },
                    backgroundColor: .customGreen,
                    isEnabled: registerViewModel.isRegisterEnabled()
                )
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            
            if registerViewModel.showResendOptions {
                HStack(spacing: 4) {
                    Text("Didn't receive the email?")
                    
                    
                    Button(action: {
                        Task {
                            await registerViewModel.resendEmailVerification()
                        }
                    }) {
                        Text("Resend")
                            .fontWeight(.semibold)
                            .foregroundColor(registerViewModel
                                .resendButtonColor())
                    }
                    .disabled(!registerViewModel.isResendEnabled)
                    
                    if !registerViewModel.isResendEnabled {
                        Text(registerViewModel.timerText)
                    }
                }
                .font(.footnote)
                .foregroundColor(.secondary)
                .padding(.bottom, 5)
            }
            
            Text("To register, please provide a valid email address and create a password that is at least 6 characters long. After completing the registration form, an email will be sent to the provided address containing a verification link.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)
            
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
