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
        do {
            let _ = try await firestoreAuth.signUpFirebase(email: email,
                                                           password: password)
            showAlertAndConfigure(success: true)
        } catch {
            let authError = handleError(error as NSError)
            showAlertAndConfigure(success: false, error: authError)
        }
    }
    
    // MARK: - Resend link
    func resendEmailVerification() async {
        do {
            try await firestoreAuth.resendVerificationFirebase()
        } catch {
            self.error = handleError(error as NSError)
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
    
    private func showAlertAndConfigure(success: Bool,
                                       error: AuthError? = nil) {
        self.error = error
        self.showAlert = true
    }
    
    // MARK: - Color
        func titleColor(for text: String) -> Color {
            return text.isEmpty ? .customRed : .primary
        }
        
        // MARK: - Button State
        func isRegisterEnabled() -> Bool {
            return !email.isEmpty &&
            !password.isEmpty &&
            password == confirmPassword
        }
    
    // MARK: - Error
    private func handleError(_ nsError: NSError) -> AuthError {
        if let authErrorCode = AuthErrorCode(rawValue: nsError.code) {
            switch authErrorCode {
            case .invalidEmail:
                return .invalidEmail
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
