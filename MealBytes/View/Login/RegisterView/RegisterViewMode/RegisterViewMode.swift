//
//  RegisterViewMode.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var error: AuthError?
    @Published var showAlert: Bool = false
    
    private let firestoreAuth: FirestoreAuthProtocol = FirestoreAuth()
    
    // MARK: - Sign Up
    func signUp() async {
        guard !email.isEmpty else {
            showAlertAndConfigure(success: false, error: .emptyEmail)
            return
        }
        
        guard !password.isEmpty else {
            showAlertAndConfigure(success: false, error: .emptyPassword)
            return
        }
        
        guard password == confirmPassword else {
            showAlertAndConfigure(success: false, error: .passwordMismatch)
            return
        }
        
        do {
            let _ = try await firestoreAuth.signUpFirebase(email: email,
                                                           password: password)
            showAlertAndConfigure(success: true)
        } catch {
            let authError = handleError(error)
            showAlertAndConfigure(success: false, error: authError)
        }
    }
    
    // MARK: - Resend link
    func resendEmailVerification() async {
        do {
            try await firestoreAuth.resendVerificationFirebase()
        } catch {
            self.error = handleError(error)
        }
    }
    
    // MARK: - Alert
    func getAlert() -> Alert {
        if let error = error {
            return Alert(
                title: Text("Error"),
                message: Text(error.errorDescription ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        } else {
            return Alert(
                title: Text("Done"),
                message: Text("A confirmation email has been sent to your email address."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func showAlertAndConfigure(success: Bool, error: AuthError? = nil) {
        self.error = error
        self.showAlert = true
    }
    
    // MARK: - Error
    private func handleError(_ error: Error) -> AuthError {
        let nsError = error as NSError
        if let authErrorCode = AuthErrorCode(rawValue: nsError.code) {
            switch authErrorCode {
            case .invalidEmail:
                return .invalidEmail
            case .weakPassword:
                return .weakPassword
            case .emailAlreadyInUse:
                return .emailAlreadyInUse
            case .networkError:
                return .networkError
            default:
                return .unknownError
            }
        }
        return .unknownError
    }
}
