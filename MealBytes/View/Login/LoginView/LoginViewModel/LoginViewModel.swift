//
//  LoginViewModel.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: AuthError?
    @Published var isAuthenticated: Bool = false
    
    private let firestoreAuth: FirestoreAuthProtocol = FirestoreAuth()
    
    // MARK: - Sign In
    func signIn() async {
        guard !(email.isEmpty && password.isEmpty) else {
            self.error = .emptyFields
            return
        }
        
        guard !email.isEmpty else {
            self.error = .emptyEmail
            return
        }
        
        guard !password.isEmpty else {
            self.error = .emptyPassword
            return
        }
        
        do {
            let _ = try await firestoreAuth.signInFirebase(email: email,
                                                           password: password)
            isAuthenticated = true
        } catch {
            self.error = handleError(error)
        }
    }
    
    // MARK: - Sign Up
    func signUp() async {
        guard !email.isEmpty else {
            self.error = .emptyEmail
            return
        }
        
        guard !password.isEmpty else {
            self.error = .emptyPassword
            return
        }
        
        do {
            let _ = try await firestoreAuth.signUpFirebase(email: email,
                                                           password: password)
            isAuthenticated = true
        } catch {
            self.error = handleError(error)
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try firestoreAuth.signOutFirebase()
            isAuthenticated = false
        } catch {
            self.error = handleError(error)
        }
    }
    
    // MARK: - Reset Password
    func resetPassword() async {
        guard !email.isEmpty else {
            self.error = .emptyEmail
            return
        }
        
        do {
            try await firestoreAuth.resetPasswordFirebase(email: email)
        } catch {
            self.error = handleError(error)
        }
    }
    
    // MARK: - Delete Account
    func deleteAccount() async {
        do {
            try await firestoreAuth.deleteAccountFirebase()
            isAuthenticated = false
        } catch {
            self.error = handleError(error)
        }
    }
    
    // MARK: - Error Handling
    private func handleError(_ error: Error) -> AuthError {
        if let authError = error as? AuthErrorCode {
            switch authError {
            case .invalidEmail:
                return .invalidEmail
            case .wrongPassword:
                return .emptyPassword
            case .userNotFound:
                return .incorrectCredentials
            case .networkError:
                return .networkError
            default:
                return .incorrectCredentials
            }
        }
        return .incorrectCredentials
    }
}

#Preview {
    NavigationStack {
        LoginView()
    }
    .accentColor(.customGreen)
}
