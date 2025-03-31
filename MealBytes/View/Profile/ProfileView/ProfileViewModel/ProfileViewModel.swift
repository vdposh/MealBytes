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
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var destructiveButtonTitle: String = ""
    @Published var alertType: AlertType?
    @Published var appError: AppError?
    @Published var showAlert: Bool = false
    @Published var isDataLoaded: Bool = false
    
    var bindingForShouldDisplayRdi: Binding<Bool> {
        Binding(
            get: { self.mainViewModel.shouldDisplayRdi },
            set: { newValue in
                self.mainViewModel.shouldDisplayRdi = newValue
                Task {
                    await self.mainViewModel.saveDisplayRdiMainView(newValue)
                }
            }
        )
    }
    
    @ObservedObject var loginViewModel: LoginViewModel
    @ObservedObject var mainViewModel: MainViewModel
    private let firestoreAuth: FirestoreAuthProtocol = FirestoreAuth()
    
    init(loginViewModel: LoginViewModel,
         mainViewModel: MainViewModel) {
        self.loginViewModel = loginViewModel
        self.mainViewModel = mainViewModel
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try firestoreAuth.signOutFirebase()
            Task {
                await MainActor.run {
                    loginViewModel.isLoggedIn = false
                }
            }
        } catch {
            appError = .decoding
        }
    }
    
    // MARK: - Delete Account
    func deleteAccount(email: String, password: String) async {
        do {
            try await firestoreAuth.reauthenticateFirebase(email: email,
                                                           password: password)
            try await firestoreAuth.deleteAccountFirebase()
            Task {
                await MainActor.run {
                    loginViewModel.isLoggedIn = false
                }
            }
        } catch {
            Task {
                await MainActor.run {
                    appError = .decoding
                }
            }
        }
    }
    
    // MARK: - Fetch Current User Email
    func fetchCurrentUserEmail() async {
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
    
    // MARK: - Load Data
    func loadProfileData() async {
        isDataLoaded = false
        await mainViewModel.loadDisplayRdiMainView()
        await fetchCurrentUserEmail()
        Task {
            await MainActor.run {
                isDataLoaded = true
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
                    alertTitle = "Sign out"
                    alertMessage = "You will need to sign in again to access your account."
                    destructiveButtonTitle = "Sign Out"
                case .deleteAccount:
                    alertTitle = "Delete Account"
                    alertMessage = """
                    To delete your account, please enter the password associated with your account.
                    Your data and account details will be permanently erased. This action cannot be undone.
                    """
                    destructiveButtonTitle = "Delete"
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
            
            guard !password.isEmpty else {
                alertTitle = "Delete Account"
                alertMessage = "Password is missing. To delete your account, please enter the password associated with your account."
                showAlert = true
                return
            }
            
            do {
                try await firestoreAuth.reauthenticateFirebase(
                    email: email,
                    password: password
                )
                await deleteAccount(email: email, password: password)
            } catch {
                alertTitle = "Delete Account"
                alertMessage = "The password you entered is incorrect. To delete your account, please provide the correct password."
                showAlert = true
            }
        }
    }
    
    enum AlertType {
        case signOut
        case deleteAccount
    }
}
