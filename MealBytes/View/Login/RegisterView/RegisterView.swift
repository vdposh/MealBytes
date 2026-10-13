//
//  RegisterView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/03/2025.
//

import SwiftUI

struct RegisterView: View {
    @FocusState private var registerFocus: RegisterField?
    @StateObject private var registerViewModel = RegisterViewModel()
    
    var body: some View {
        registerViewContentBody
            .navigationTitle("Create account")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                registerViewToolbar
            }
            .alert(isPresented: $registerViewModel.showAlert) {
                registerViewModel.getAlert()
            }
            .task {
                registerFocus = .email
            }
    }
    
    private var registerViewContentBody: some View {
        Form {
            Section {
                LoginTextFieldView(
                    text: $registerViewModel.email,
                    focus: $registerFocus,
                    focusCase: .email,
                    textContentType: .emailAddress,
                    onSubmit: {
                        registerFocus = .password
                    }
                )
                
                SecureFieldView(
                    text: $registerViewModel.password,
                    focus: $registerFocus,
                    focusCase: .password,
                    textContentType: .newPassword,
                    submitLabel: .next,
                    onSubmit: {
                        registerFocus = .confirmPassword
                    }
                )
                
                SecureFieldView(
                    text: $registerViewModel.confirmPassword,
                    focus: $registerFocus,
                    focusCase: .confirmPassword,
                    placeholder: "Confirm Password",
                    textContentType: .password,
                    onSubmit: {
                        Task {
                            await registerViewModel.signUp()
                        }
                    }
                )
            } footer: {
                Text("Enter email and create a password (min 6 characters). A verification email will be sent.")
            }
        }
        .disabled(registerViewModel.registerState == .loading)
    }
    
    @ToolbarContentBuilder
    private var registerViewToolbar: some ToolbarContent {
        ToolbarItem(placement: .confirmationAction) {
            switch registerViewModel.registerState {
            case .loading:
                ProgressView()
                
            case .resend:
                if registerViewModel.isResendEnabled {
                    Button(role: .confirm) {
                        Task {
                            await registerViewModel.resendEmailVerification()
                        }
                    } label: {
                        Text("Resend")
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    }
                    .disabled(registerViewModel.isRegisterLoading)
                } else {
                    Text(registerViewModel.timerText)
                        .fontWeight(.medium)
                        .frame(width: 65)
                }
                
            case .register:
                Button(role: .confirm) {
                    Task {
                        await registerViewModel.signUp()
                    }
                }
                .disabled(!registerViewModel.isRegisterEnabled())
            }
        }
    }
    
    enum RegisterField: Hashable {
        case email
        case password
        case confirmPassword
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}

#Preview {
    PreviewLoginView.loginView
}
