//
//  ProfileViewModel.swift
//  MealBytes
//
//  Created by Porshe on 30/03/2025.
//

import SwiftUI
import FirebaseAuth

final class ProfileViewModel: ObservableObject {
    @Published var email: String?
    @Published var password: String = ""
    @Published var newPassword: String = ""
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var destructiveButtonTitle: String = ""
    @Published var alertType: AlertType?
    @Published var appError: AppError?
    @Published var showAlert: Bool = false
    @Published var isToggleUpdating: Bool = false
    
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var mainViewModel: MainViewModel
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    
    init(loginViewModel: LoginViewModel,
         mainViewModel: MainViewModel) {
        self.loginViewModel = loginViewModel
        self.mainViewModel = mainViewModel
    }
    
    // MARK: - Toggle
    func updateShouldDisplayRdi(to newValue: Bool) {
        Task {
            await MainActor.run {
                self.isToggleUpdating = true
                self.mainViewModel.shouldDisplayRdi = newValue
            }
            await self.mainViewModel.saveDisplayRdiMainView(newValue)
            await MainActor.run {
                self.isToggleUpdating = false
            }
        }
    }
    
    // MARK: - Sign Out
    private func signOut() {
        do {
            try firebaseAuth.signOutAuth()
            loginViewModel.isLoggedIn = false
            UserDefaults.standard.setValue(false, forKey: "isLoggedIn")
            UserDefaults.standard.removeObject(forKey: "lastEmail")
        } catch {
            appError = .decoding
        }
    }
    
    // MARK: - Delete Account
    private func deleteAccount(email: String, password: String) async {
        do {
            try await firebaseAuth.reauthenticateAuth(email: email,
                                                      password: password)
            try await firebaseAuth.deleteAccountAuth()
            Task {
                await MainActor.run {
                    loginViewModel.isLoggedIn = false
                    UserDefaults.standard.setValue(false, forKey: "isLoggedIn")
                    UserDefaults.standard.removeObject(forKey: "lastEmail")
                }
            }
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Change Password
    func changePassword(currentPassword: String, newPassword: String) async {
        guard !currentPassword.isEmpty, !newPassword.isEmpty else {
            return
        }
        
        do {
            try await firebaseAuth.changePasswordAuth(
                currentPassword: currentPassword,
                newPassword: newPassword
            )
        } catch {
            await MainActor.run {
                appError = .decoding
            }
        }
    }
    
    // MARK: - Load Data
    func loadProfileData() async {
        guard let user = Auth.auth().currentUser else {
            Task {
                await MainActor.run {
                    email = nil
                }
            }
            return
        }
        Task {
            await MainActor.run {
                email = user.email
            }
        }
    }
    
    // MARK: - Alert
    func prepareAlert(for type: AlertType) {
        Task {
            await MainActor.run {
                alertType = type
                showAlert = true
                
                switch type {
                case .signOut:
                    alertTitle = "Sign Out"
                    alertMessage = "You will need to sign in again to access your account."
                    destructiveButtonTitle = "Sign Out"
                    
                case .deleteAccount:
                    alertTitle = "Delete Account"
                    alertMessage = """
                    To delete your account, please enter the password associated with your account.
                    Your data and account details will be permanently erased. This action cannot be undone.
                    """
                    destructiveButtonTitle = "Delete"
                    
                case .changePassword:
                    alertTitle = "Change Password"
                    alertMessage = "Please provide your current password and a new password to update your account credentials."
                    destructiveButtonTitle = "Update Password"
                }
            }
        }
    }
    
    func handleAlertAction() async {
        guard let alertType = alertType else { return }
        
        switch alertType {
        case .signOut:
            signOut()
            
        case .deleteAccount:
            guard let email = email, !email.isEmpty else {
                alertTitle = "Delete Account"
                alertMessage = "Email is missing."
                showAlert = true
                return
            }
            
            do {
                try await firebaseAuth.reauthenticateAuth(
                    email: email,
                    password: password
                )
                await deleteAccount(email: email, password: password)
            } catch {
                alertTitle = "Delete Account"
                alertMessage = """
                The password you entered is incorrect.
                To delete your account, please provide the correct password.
                """
                showAlert = true
            }
            
        case .changePassword:
            do {
                try await firebaseAuth.changePasswordAuth(
                    currentPassword: password,
                    newPassword: newPassword
                )
                alertTitle = "Done"
                alertMessage = "Your password has been successfully updated."
                showAlert = true
            } catch {
                alertTitle = "Change Password"
                alertMessage = """
                Failed to update the password.
                Please check your current password and try again.
                """
                showAlert = true
            }
        }
    }
    
    enum AlertType {
        case signOut
        case deleteAccount
        case changePassword
    }
}
