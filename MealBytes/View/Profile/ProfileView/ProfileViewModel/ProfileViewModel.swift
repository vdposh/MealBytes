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
        
        switch type {
        case .signOut:
            alertContent = AlertContentProfile(
                title: "Sign Out",
                message: "Signing out will require signing in again to access the account.",
                destructiveTitle: "Sign Out",
                type: .signOut
            )
            
        case .deleteAccount:
            alertContent = AlertContentProfile(
                title: "Delete Account",
                message: """
                    To delete the account, enter the password associated with it.
                    Data and account details will be permanently erased. This action cannot be undone.
                    """,
                destructiveTitle: "Delete",
                type: .deleteAccount
            )
            
        case .changePassword:
            alertContent = AlertContentProfile(
                title: "Change Password",
                message: "Provide the current password and a new password to update account credentials.",
                destructiveTitle: "Update Password",
                type: .changePassword
            )
        }
        
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
                await MainActor.run {
                    alertContent = AlertContentProfile(
                        title: "Delete Account",
                        message: "Email is missing.",
                        destructiveTitle: "Delete",
                        type: .deleteAccount
                    )
                    showAlert = true
                    isDeletingAccount = false
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
                    alertContent = AlertContentProfile(
                        title: "Delete Account",
                        message: """
                        The password entered is incorrect.
                        To delete the account, provide the correct password.
                        """,
                        destructiveTitle: "Delete",
                        type: .deleteAccount
                    )
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
                    alertContent = AlertContentProfile(
                        title: "Change Password",
                        message: """
                        Failed to update the password.
                        The password must be at least 6 characters long.
                        """,
                        destructiveTitle: "Update Password",
                        type: .changePassword
                    )
                    showAlert = true
                    isPasswordChanging = false
                }
                return
            }
            
            guard newPassword == confirmPassword else {
                await MainActor.run {
                    alertContent = AlertContentProfile(
                        title: "Change Password",
                        message: """
                        Failed to update the password.
                        New password and confirmation do not match.
                        """,
                        destructiveTitle: "Update Password",
                        type: .changePassword
                    )
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
                    alertContent = AlertContentProfile(
                        title: "Done",
                        message: "Password has been successfully updated.",
                        destructiveTitle: "OK",
                        type: .changePassword
                    )
                    showAlert = true
                    isPasswordChanging = false
                }
            } catch {
                await MainActor.run {
                    alertContent = AlertContentProfile(
                        title: "Change Password",
                        message: """
                        Failed to update the password.
                        Check the current password and try again.
                        """,
                        destructiveTitle: "Update Password",
                        type: .changePassword
                    )
                    showAlert = true
                    isPasswordChanging = false
                }
            }
        }
    }
    
    var destructiveTitle: String {
        alertContent?.destructiveTitle ?? defaultDestructiveTitle
    }
    
    private var defaultDestructiveTitle: String {
        switch alertContent?.type {
        case .signOut: return "Sign Out"
        case .deleteAccount: return "Delete Account"
        case .changePassword: return "Update Password"
        default: return "Confirm"
        }
    }
    
    //MARK: - Reset State
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
    var isLoading: Bool {
        isDeletingAccount || isPasswordChanging
    }
}

enum AlertTypeProfileView {
    case signOut
    case deleteAccount
    case changePassword
}

#Preview {
    PreviewContentView.contentView
}
