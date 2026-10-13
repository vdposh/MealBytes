//
//  EmailView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 10.09.2026.
//

import SwiftUI

struct EmailView: View {
    @FocusState private var emailFocus: Bool?
    @StateObject private var emailViewModel = EmailViewModel()
    
    init(currentEmail: String = "") {
        _emailViewModel = StateObject(
            wrappedValue: EmailViewModel(currentEmail: currentEmail)
        )
    }
    
    var body: some View {
        emailViewContentBody
            .navigationTitle("Email")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                emailViewToolbar
            }
            .alert(
                emailViewModel.alertTitle,
                isPresented: emailAlertBinding,
                actions: {
                    alertActions
                },
                message: {
                    Text(emailViewModel.alertMessage)
                }
            )
            .task {
                emailFocus = true
            }
    }
    
    private var emailViewContentBody: some View {
        Form {
            Section {
                LoginTextFieldView(
                    text: $emailViewModel.newEmail,
                    focus: $emailFocus,
                    focusCase: true,
                    placeholder: "New Email",
                    textContentType: .emailAddress,
                    submitLabel: .done,
                    onSubmit: {
                        Task {
                            await emailViewModel.changeEmail()
                        }
                    }
                )
            } footer: {
                Text("Enter a new email. A verification link will be sent to it.")
            }
        }
        .disabled(emailViewModel.isLoading)
    }
    
    @ToolbarContentBuilder
    private var emailViewToolbar: some ToolbarContent {
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
    
    private var emailAlertBinding: Binding<Bool> {
        Binding(
            get: { emailViewModel.alertType != nil },
            set: { newValue in
                if !newValue {
                    Task { @MainActor in
                        emailViewModel.alertType = nil
                    }
                }
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
