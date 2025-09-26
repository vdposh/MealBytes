//
//  ProfileViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/03/2025.
//

import SwiftUI
import FirebaseAuth

final class ProfileViewModel: ObservableObject {
    @Published var email: String?
    @Published var uniqueId = UUID()
    @Published var password: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var alertContent: AlertContentProfile?
    @Published var appError: AppError?
    @Published var showAlert: Bool = false
    @Published var isPasswordChanging: Bool = false
    @Published var isDeletingAccount: Bool = false
    
    @ObservedObject var loginViewModel: LoginViewModel
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    let mainViewModel: MainViewModelProtocol
    
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
        uniqueId = UUID()
        
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
        uniqueId = UUID()
        
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
        alertContent = AlertContentProfile(type: type)
        showAlert = true
    }
    
    func handleAlertAction() async {
        guard let alertType = alertContent?.type else { return }
        
        switch alertType {
        case .signOut:
            signOut()
            
        case .deleteAccount:
            isDeletingAccount = true
            
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
            isPasswordChanging = true
            
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
                    for: .changePassword,
                    isSuccess: true
                )
            } catch {
                await showOverrideMessage(
                    ProfileMessage.passwordUpdateFailed.text,
                    for: .changePassword
                )
            }
        }
    }
    
    private func validatePassword() -> PasswordError? {
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
        for type: AlertTypeProfileView,
        isSuccess: Bool = false
    ) async {
        await MainActor.run {
            alertContent = AlertContentProfile(
                type: type,
                overrideMessage: message,
                isSuccess: isSuccess
            )
            showAlert = true
            isPasswordChanging = false
            isDeletingAccount = false
        }
    }
    
    // MARK: - Reset State
    private func resetProfileState() {
        password = ""
        newPassword = ""
        confirmPassword = ""
        alertContent = nil
        showAlert = false
        appError = nil
        isPasswordChanging = false
        isDeletingAccount = false
        
        loginViewModel.resetLoginState()
    }
    
    // MARK: - UI Helper
    var alertTitle: String {
        alertContent?.title ?? "Alert"
    }
    
    var alertMessage: String {
        alertContent?.message ?? ""
    }
    
    var destructiveTitle: String {
        alertContent?.destructiveTitle ?? "Confirm"
    }
    
    var isLoading: Bool {
        isPasswordChanging || isDeletingAccount
    }
}

#Preview {
    PreviewContentView.contentView
}
