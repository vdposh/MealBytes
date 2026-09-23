//
//  EmailView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 10.09.2026.
//

import SwiftUI

struct EmailView: View {
    @StateObject private var emailViewModel = EmailViewModel()
    
    init(currentEmail: String = "") {
        _emailViewModel = StateObject(
            wrappedValue: EmailViewModel(currentEmail: currentEmail)
        )
    }
    
    var body: some View {
        Form {
            Section {
                LoginTextFieldView(
                    text: $emailViewModel.newEmail,
                    placeholder: "New Email"
                )
            } footer: {
                Text("Enter a new email. A verification link will be sent to it.")
            }
        }
        .navigationTitle("Email")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if emailViewModel.isLoading {
                    ProgressView()
                } else {
                    Button(role: .confirm) {
                        Task {
                            await emailViewModel.changeEmail()
                        }
                    }
                    .disabled(!emailViewModel.isFormValid)
                }
            }
        }
        .alert(
            emailViewModel.alertTitle,
            isPresented: Binding(
                get: { emailViewModel.alertType != nil },
                set: { if !$0 { emailViewModel.alertType = nil } }
            ),
            actions: {
                alertActions
            },
            message: {
                Text(emailViewModel.alertMessage)
            }
        )
    }
    
    @ViewBuilder
    private var alertActions: some View {
        switch emailViewModel.alertType {
        case .password:
            SecureField("Current Password", text: $emailViewModel.password)
            
            Button(role: .cancel) {
                emailViewModel.password = ""
                emailViewModel.alertType = nil
            }
            
            Button(role: .confirm) {
                Task {
                    await emailViewModel.confirmChangeEmail()
                }
            }
            .keyboardShortcut(.defaultAction)
            .disabled(emailViewModel.password.isEmpty)
            
        case .error, .success:
            Button("OK") {
                emailViewModel.alertType = nil
            }
            
        case .none:
            EmptyView()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewProfileView.profileView
}

#Preview {
    NavigationStack {
        EmailView()
    }
}
