//
//  ResendEmailView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 26/09/2025.
//

import SwiftUI

struct ResendEmailView: View {
    @ObservedObject var registerViewModel: RegisterViewModel
    
    var body: some View {
        HStack(spacing: 5) {
            Text("Didn't receive the email?")
            
            Button("Resend") {
                Task {
                    await registerViewModel.resendEmailVerification()
                }
            }
            .fontWeight(.semibold)
            .foregroundStyle(registerViewModel.resendButtonColor())
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
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
