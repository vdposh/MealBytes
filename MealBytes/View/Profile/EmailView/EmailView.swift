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
                    placeholder: "New Email",
                    showLabel: false
                )
            } footer: {
                Text("Enter a new email. A verification link will be sent to confirm the change.")
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
            isPresented: $emailViewModel.showAlert,
            actions: {
                Button("OK") {
                    emailViewModel.showAlert = false
                }
            },
            message: {
                Text(emailViewModel.alertMessage)
            }
        )
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
