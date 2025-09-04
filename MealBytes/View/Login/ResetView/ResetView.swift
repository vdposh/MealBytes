//
//  ResetView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/03/2025.
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
                
                LoginTextFieldView(
                    text: $resetViewModel.email,
                    titleColor: resetViewModel.titleColor(
                        for: resetViewModel.email
                    )
                )
                
                if resetViewModel.isLoading {
                    LoadingView(showFrame: true)
                } else if resetViewModel.isEmailSent {
                    Text("A reset link has been sent to the email \"\(resetViewModel.sentEmail)\".")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                } else {
                    ActionButtonView(
                        title: "Send reset link on email",
                        action: {
                            Task {
                                await resetViewModel.resetPassword()
                            }
                        },
                        isEnabled: resetViewModel.isResetEnabled()
                    )
                    .frame(height: 50)
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            
            Text("Enter the email used during registration. A reset link will be sent to this email with instructions on how to create a new password and regain access to your account.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 30)
            
                .alert(isPresented: $resetViewModel.showAlert) {
                    resetViewModel.getAlert()
                }
        }
    }
}

#Preview {
    NavigationStack {
        ResetView()
    }
}
