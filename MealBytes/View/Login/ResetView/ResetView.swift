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
            resetViewFooter
        }
        .alert(isPresented: $resetViewModel.showAlert) {
            resetViewModel.getAlert()
        }
    }
    
    private var resetViewContentBody: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Reset Password")
                .font(.title)
                .fontWeight(.bold)
            
            LoginTextFieldView(
                text: $resetViewModel.email
            )
            
            resetStateContent
        }
        .padding(.horizontal, 30)
    }
    
    @ViewBuilder
    private var resetStateContent: some View {
        switch resetViewModel.resetState {
        case .loading:
            LoadingView(showFrame: true)
            
        case .emailSent:
            Text("A reset link has been sent to the email \"\(resetViewModel.sentEmail)\".")
                .font(.footnote)
                .foregroundStyle(.secondary)
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
            .frame(height: 50)
        }
    }
    
    private var resetViewFooter: some View {
        Text("Enter the email used during registration. A reset link will be sent to this email with instructions on how to create a new password and regain access to your account.")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding(.horizontal, 30)
            .padding(.top, 15)
    }
}

#Preview {
    NavigationStack {
        ResetView()
    }
}
