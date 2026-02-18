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
            resetViewContentBody
                .navigationTitle("Reset Password")
                .navigationBarTitleDisplayMode(.inline)
        }
        .alert(isPresented: $resetViewModel.showAlert) {
            resetViewModel.getAlert()
        }
    }
    
    private var resetViewContentBody: some View {
        Form {
            Section {
                LoginTextFieldView(
                    text: $resetViewModel.email
                )
            } footer: {
                VStack(spacing: 20) {
                    resetStateContent
                    
                    Text("Enter the email used during registration. A reset link will be sent to this email with instructions on how to create a new password and regain access to your account.")
                }
                .padding(.vertical)
            }
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private var resetStateContent: some View {
        switch resetViewModel.resetState {
        case .loading:
            LoadingView(showFrame: true)
            
        case .emailSent:
            Text("A reset link has been sent to the email \(Text(resetViewModel.sentEmail).fontWeight(.semibold))")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            
        case .ready:
            ActionButtonView(
                title: "Send reset link on email",
                action: {
                    Task {
                        await resetViewModel.resetPassword()
                    }
                },
                isEnabled: resetViewModel.isResetEnabled()
            )
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    ResetView()
}

#Preview {
    PreviewLoginView.loginView
}
