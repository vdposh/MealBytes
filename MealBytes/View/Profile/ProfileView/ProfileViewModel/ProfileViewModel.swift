//
//  ProfileViewModel.swift
//  MealBytes
//
//  Created by Porshe on 30/03/2025.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var email: String?
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var destructiveButtonTitle: String = ""
    @Published var alertType: AlertType?
    @Published var appError: AppError?
    @Published var showAlert: Bool = false
    
    @ObservedObject var loginViewModel: LoginViewModel
    private let firestoreAuth: FirestoreAuthProtocol = FirestoreAuth()
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try firestoreAuth.signOutFirebase()
            loginViewModel.isLoggedIn = false
        } catch {
            appError = .decoding
        }
    }
    
    // MARK: - Delete Account
    func deleteAccount() async {
        do {
            try await firestoreAuth.deleteAccountFirebase()
            loginViewModel.isLoggedIn = false
        } catch {
            appError = .decoding
        }
    }
    
    // MARK: - Fetch Current User Email
    func fetchCurrentUserEmail() async {
        guard let user = Auth.auth().currentUser else {
            email = nil
            return
        }
        email = user.email
    }
    
    // MARK: - Alert
    func prepareAlert(for type: AlertType) {
        alertType = type
        showAlert = true
        
        switch type {
        case .signOut:
            alertTitle = "Are you sure you want to sign out?"
            alertMessage = "You will need to sign in again to access your account."
            destructiveButtonTitle = "Sign Out"
        case .deleteAccount:
            alertTitle = "Are you sure you want to delete your profile?"
            alertMessage = "All your data, preferences, and account details will be permanently erased. This action cannot be undone."
            destructiveButtonTitle = "Delete"
        }
    }
    
    func handleAlertAction() {
        switch alertType {
        case .signOut:
            signOut()
        case .deleteAccount:
            Task {
                await deleteAccount()
            }
        case .none:
            break
        }
    }
    
    enum AlertType {
        case signOut
        case deleteAccount
    }
}

#Preview {
    ContentView()
        .accentColor(.customGreen)
}
