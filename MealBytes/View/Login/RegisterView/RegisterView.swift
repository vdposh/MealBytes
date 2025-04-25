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
                
                LoginTextFieldView(
                    text: $registerViewModel.email,
                    titleColor: registerViewModel.titleColor(
                        for: registerViewModel.email)
                )
                
                SecureFieldView(
                    text: $registerViewModel.password,
                    title: "Password",
                    placeholder: "Enter password",
                    titleColor: registerViewModel.titleColor(
                        for: registerViewModel.password)
                )
                
                SecureFieldView(
                    text: $registerViewModel.confirmPassword,
                    title: "Confirm Password",
                    placeholder: "Re-enter password",
                    titleColor: registerViewModel.titleColor(
                        for: registerViewModel.confirmPassword)
                )
                
                if registerViewModel.isRegisterLoading {
                    LoadingView()
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                } else {
                    if registerViewModel.showResendOptions {
                        HStack(spacing: 4) {
                            Text("Didn't receive the email?")
                            
                            Button {
                                Task {
                                    await registerViewModel
                                        .resendEmailVerification()
                                }
                            } label: {
                                Text("Resend")
                                    .fontWeight(.semibold)
                                    .foregroundColor(
                                        registerViewModel.resendButtonColor()
                                    )
                            }
                            .disabled(
                                registerViewModel.isRegisterLoading ||
                                !registerViewModel.isResendEnabled
                            )
                            
                            if !registerViewModel.isResendEnabled {
                                Text(registerViewModel.timerText)
                                    .frame(width: 50, alignment: .leading)
                            }
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                    } else {
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
                        .frame(height: 50)
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            
            Text("To register, provide a valid email address and create a password that is at least 6 characters long. Once done, you'll receive a verification email.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 30)
            
                .alert(isPresented: $registerViewModel.showAlert) {
                    registerViewModel.getAlert()
                }
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
