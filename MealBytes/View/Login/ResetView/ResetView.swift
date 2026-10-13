//
//  ResetView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/03/2025.
//

import SwiftUI

struct ResetView: View {
    @FocusState private var resetFocus: Bool?
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
            .task {
                resetFocus = true
            }
    }
    
    private var resetViewContentBody: some View {
        Form {
            Section {
                LoginTextFieldView(
                    text: $resetViewModel.email,
                    focus: $resetFocus,
                    focusCase: true,
                    submitLabel: .done,
                    onSubmit: {
                        Task {
                            await resetViewModel.resetPassword()
                        }
                    }
                )
            } footer: {
                Text("Enter email to request a password reset link.")
            }
        }
        .disabled(resetViewModel.isLoading)
    }
    
    @ToolbarContentBuilder
    private var resetViewToolbar: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            if resetViewModel.isLoading {
                ProgressView()
            } else {
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
