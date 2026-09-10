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
        resetViewContentBody
            .navigationTitle("Forgot Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                resetViewToolbar
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
                Text("Enter email to request a password reset link.")
            }
        }
    }
    
    @ToolbarContentBuilder
    private var resetViewToolbar: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            switch resetViewModel.resetState {
            case .loading:
                ProgressView()
                
            case .emailSent:
                EmptyView()
                
            case .ready:
                Button(role: .confirm) {
                    Task {
                        await resetViewModel.resetPassword()
                    }
                }
                .disabled(!resetViewModel.isResetEnabled())
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    NavigationStack {
        ResetView()
    }
}

#Preview {
    PreviewLoginView.loginView
}
