//
//  ResetView.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI

struct ResetView: View {
    @StateObject private var resetViewModel = ResetViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Reset password")
                    .font(.title)
                    .fontWeight(.bold)
                
                ServingTextFieldView(
                    text: $resetViewModel.email,
                    title: "Email",
                    placeholder: "Enter your email",
                    keyboardType: .emailAddress,
                    titleColor: resetViewModel.titleColor(
                        for: resetViewModel.email)
                )
                .autocapitalization(.none)
                .disableAutocorrection(true)
                
                if resetViewModel.isLoading {
                    LoadingView()
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                } else {
                    ActionButtonView(
                        title: "Send reset link on email",
                        action: {
                            Task {
                                await resetViewModel.resetPassword()
                            }
                        },
                        backgroundColor: .customGreen,
                        isEnabled: resetViewModel.isResetEnabled()
                    )
                    .frame(height: 50)
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            
            Text("Enter the email address you used during registration. A message will be sent to this email containing instructions to reset your password. By following the link in the email, you will be able to create a new password and regain access to your account.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)
            
                .alert(isPresented: $resetViewModel.showAlert) {
                    resetViewModel.getAlert()
                }
        }
    }
}
