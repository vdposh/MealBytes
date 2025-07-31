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
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var destructiveButtonTitle: String = ""
    @Published var alertType: AlertType?
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
    private func signOut() {
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
    func prepareAlert(for type: AlertType) {
        Task {
            await MainActor.run {
                password = ""
                newPassword = ""
                confirmPassword = ""
                
                alertType = type
                showAlert = true
                
                switch type {
                case .signOut:
                    alertTitle = "Sign Out"
                    alertMessage = "Signing out will require signing in again to access the account."
                    destructiveButtonTitle = "Sign Out"
                    
                case .deleteAccount:
                    alertTitle = "Delete Account"
                    alertMessage = """
                    To delete the account, enter the password associated with it.
                    Data and account details will be permanently erased. This action cannot be undone.
                    """
                    destructiveButtonTitle = "Delete"
                    
                case .changePassword:
                    alertTitle = "Change Password"
                    alertMessage = "Provide the current password and a new password to update account credentials."
                    destructiveButtonTitle = "Update Password"
                }
            }
        }
    }
    
    func handleAlertAction() async {
        guard let alertType else { return }
        
        switch alertType {
        case .signOut:
            signOut()
            
        case .deleteAccount:
            await MainActor.run {
                isDeletingAccount = true
            }
            
            guard let email = email, !email.isEmpty else {
                await MainActor.run {
                    alertTitle = "Delete Account"
                    alertMessage = "Email is missing."
                    showAlert = true
                    isDeletingAccount = true
                }
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
                await MainActor.run {
                    alertTitle = "Delete Account"
                    alertMessage = """
                    The password entered is incorrect.
                    To delete the account, provide the correct password.
                    """
                    showAlert = true
                    isDeletingAccount = false
                }
            }
            
        case .changePassword:
            await MainActor.run {
                isPasswordChanging = true
            }
            
            guard newPassword.count >= 6 else {
                await MainActor.run {
                    alertTitle = "Change Password"
                    alertMessage = """
                    Failed to update the password.
                    The password must be at least 6 characters long.
                    """
                    showAlert = true
                    isPasswordChanging = false
                }
                return
            }
            
            guard newPassword == confirmPassword else {
                await MainActor.run {
                    alertTitle = "Change Password"
                    alertMessage = """
                    Failed to update the password.
                    New password and confirmation do not match.
                    """
                    showAlert = true
                    isPasswordChanging = false
                }
                return
            }
            
            do {
                try await changePassword(
                    currentPassword: password,
                    newPassword: newPassword
                )
                await MainActor.run {
                    alertTitle = "Done"
                    alertMessage = "Password has been successfully updated."
                    showAlert = true
                    isPasswordChanging = false
                }
            } catch {
                await MainActor.run {
                    alertTitle = "Change Password"
                    alertMessage = """
                    Failed to update the password.
                    Check the current password and try again.
                    """
                    showAlert = true
                    isPasswordChanging = false
                }
            }
        }
    }
    
    //MARK: - Reset State
    func resetProfileState() {
        password = ""
        newPassword = ""
        confirmPassword = ""
        alertTitle = ""
        alertMessage = ""
        destructiveButtonTitle = ""
        alertType = nil
        appError = nil
        showAlert = false
        isPasswordChanging = false
        isDeletingAccount = false
        
        loginViewModel.resetLoginState()
    }
    
    // MARK: - UI Helper
    var isLoading: Bool {
        isDeletingAccount || isPasswordChanging
    }
}

enum AlertType {
    case signOut
    case deleteAccount
    case changePassword
}

#Preview {
    PreviewContentView.contentView
}
