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
    @Published var showAlert = false
    
    let registerView = RegisterView()
    let resetView = ResetView()
    private let firestoreAuth: FirestoreAuthProtocol = FirestoreAuth()
    
    // MARK: - Sign In
    func signIn() async {
        guard !(email.isEmpty && password.isEmpty) else {
            self.error = .emptyFields
            updateAlertState()
            return
        }
        
        guard !email.isEmpty else {
            self.error = .emptyEmail
            updateAlertState()
            return
        }
        
        guard !password.isEmpty else {
            self.error = .emptyPassword
            updateAlertState()
            return
        }
        
        do {
            let _ = try await firestoreAuth.signInFirebase(email: email,
                                                           password: password)
            isAuthenticated = true
            self.error = nil
            updateAlertState()
        } catch {
            self.error = handleError(error)
            updateAlertState()
        }
    }
    
    // MARK: - Alert
    func updateAlertState() {
        showAlert = error != nil
    }
    
    func getAlert() -> Alert {
        if let error = error {
            return Alert(
                title: Text("Error"),
                message: Text(error.errorDescription ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        } else {
            return Alert(
                title: Text("Unknown"),
                message: Text("Something went wrong"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Error
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
