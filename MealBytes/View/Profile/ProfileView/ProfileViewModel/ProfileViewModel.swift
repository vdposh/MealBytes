//
//  ProfileViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/03/2025.
//

import SwiftUI
import Combine
import FirebaseAuth

final class ProfileViewModel: ObservableObject {
    @Published var email: String?
    @Published var password: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var overrideAlertMessage: String?
    @Published var alertContent: AlertContentProfile?
    @Published var appError: AppError?
    @Published var showAlert: Bool = false
    @Published var isPasswordChanging: Bool = false
    @Published var isDeletingAccount: Bool = false
    
    @ObservedObject var loginViewModel: LoginViewModel
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    let mainViewModel: MainViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        loginViewModel: LoginViewModel,
        mainViewModel: MainViewModelProtocol
    ) {
        self.loginViewModel = loginViewModel
        self.mainViewModel = mainViewModel
    }
    
    // MARK: - Load Profile Data
    func loadProfileData() async {
        guard let user = Auth.auth().currentUser else {
            await MainActor.run {
                email = nil
            }
            return
        }
        
        await MainActor.run {
            email = user.email
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try firebaseAuth.signOutAuth()
            
            Task {
                do {
                    try await firestore.deleteLoginDataFirestore()
                } catch {
                    appError = .network
                }
            }
            
            resetProfileState()
        } catch {
            appError = .decoding
        }
    }
    
    // MARK: - Delete Account
    private func deleteAccount(email: String, password: String) async {
        do {
            try await firebaseAuth.reauthenticateAuth(
                email: email,
                password: password
            )
            try await firebaseAuth.deleteAccountAuth()
            
            do {
                try await firestore.deleteLoginDataFirestore()
            } catch {
                await MainActor.run {
                    appError = .network
                }
            }
            
            resetProfileState()
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Change Password
    private func changePassword(
        currentPassword: String,
        newPassword: String
    ) async throws {
        try await firebaseAuth.changePasswordAuth(
            currentPassword: currentPassword,
            newPassword: newPassword
        )
    }
    
    // MARK: - Alert
    func prepareAlert(for type: AlertTypeProfileView) {
        password = ""
        newPassword = ""
        confirmPassword = ""
        overrideAlertMessage = nil
        alertContent = AlertContentProfile(type: type)
        showAlert = true
    }
    
    func handleAlertAction() async {
        guard let alertType = alertContent?.type else { return }
        
        switch alertType {
        case .signOut:
            signOut()
            
        case .deleteAccount:
            await MainActor.run {
                isDeletingAccount = true
            }
            
            guard let email = email, !email.isEmpty else {
                await showOverrideMessage(
                    ProfileMessage.emailMissing.text,
                    for: .deleteAccount
                )
                return
            }
            
            do {
                try await firebaseAuth.reauthenticateAuth(
                    email: email,
                    password: password
                )
                
                await deleteAccount(email: email, password: password)
                
                await MainActor.run {
                    isDeletingAccount = false
                }
            } catch {
                await showOverrideMessage(
                    ProfileMessage.incorrectPassword.text,
                    for: .deleteAccount
                )
            }
            
        case .changePassword:
            await MainActor.run {
                isPasswordChanging = true
            }
            
            if let validationError = validatePassword() {
                await showOverrideMessage(
                    validationError.message,
                    for: .changePassword
                )
                return
            }
            
            do {
                try await changePassword(
                    currentPassword: password,
                    newPassword: newPassword
                )
                await showOverrideMessage(
                    ProfileMessage.passwordUpdateSuccess.text,
                    for: .changePassword
                )
            } catch {
                await showOverrideMessage(
                    ProfileMessage.passwordUpdateFailed.text,
                    for: .changePassword
                )
            }
        }
    }
    
    private func validatePassword() -> PasswordValidationError? {
        if newPassword.count < 6 {
            return .tooShort
        }
        if newPassword != confirmPassword {
            return .mismatch
        }
        return nil
    }
    
    private func showOverrideMessage(
        _ message: String,
        for type: AlertTypeProfileView
    ) async {
        await MainActor.run {
            overrideAlertMessage = message
            alertContent = AlertContentProfile(type: type)
            showAlert = true
            isPasswordChanging = false
            isDeletingAccount = false
        }
    }
    
    var alertTitle: String {
        alertContent?.type.title ?? "Alert"
    }
    
    var alertMessage: String {
        overrideAlertMessage ?? alertContent?.type.defaultMessage ?? ""
    }
    
    var destructiveTitle: String {
        alertContent?.type.destructiveTitle ?? "Confirm"
    }
    
    // MARK: - Reset State
    private func resetProfileState() {
        password = ""
        newPassword = ""
        confirmPassword = ""
        alertContent = nil
        overrideAlertMessage = nil
        showAlert = false
        appError = nil
        isPasswordChanging = false
        isDeletingAccount = false
        
        loginViewModel.resetLoginState()
    }
    
    // MARK: - UI Helper
    var isLoading: Bool {
        isDeletingAccount || isPasswordChanging
    }
}

enum ProfileMessage {
    case passwordTooShort
    case passwordMismatch
    case incorrectPassword
    case emailMissing
    case passwordUpdateFailed
    case passwordUpdateSuccess
    
    var text: String {
        switch self {
        case .passwordTooShort:
            return """
            Failed to update the password.
            The password must be at least 6 characters long.
            """
        case .passwordMismatch:
            return """
            Failed to update the password.
            New password and confirmation do not match.
            """
        case .incorrectPassword:
            return """
            The password entered is incorrect.
            To delete the account, provide the correct password.
            """
        case .emailMissing:
            return "Email is missing."
        case .passwordUpdateFailed:
            return """
            Failed to update the password.
            Check the current password and try again.
            """
        case .passwordUpdateSuccess:
            return "Password has been successfully updated."
        }
    }
}

enum AlertTypeProfileView {
    case signOut
    case deleteAccount
    case changePassword
    
    var title: String {
        switch self {
        case .signOut: return "Sign Out"
        case .deleteAccount: return "Delete Account"
        case .changePassword: return "Change Password"
        }
    }
    
    var destructiveTitle: String {
        switch self {
        case .signOut: return "Sign Out"
        case .deleteAccount: return "Delete"
        case .changePassword: return "Update Password"
        }
    }
    
    var defaultMessage: String {
        switch self {
        case .signOut:
            return "Signing out will require signing in again to access the account."
        case .deleteAccount:
            return """
            To delete the account, enter the password associated with it.
            Data and account details will be permanently erased. This action cannot be undone.
            """
        case .changePassword:
            return "Provide the current password and a new password to update account credentials."
        }
    }
}

enum PasswordValidationError: Error {
    case tooShort
    case mismatch
    
    var message: String {
        switch self {
        case .tooShort:
            return ProfileMessage.passwordTooShort.text
        case .mismatch:
            return ProfileMessage.passwordMismatch.text
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
