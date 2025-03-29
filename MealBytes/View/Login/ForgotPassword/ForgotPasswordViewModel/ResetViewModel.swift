//
//  ResetViewModel.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class ResetViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var error: AuthError?
    @Published var success: Bool = false
    @Published var showAlert = false
    
    private let firestoreAuth: FirestoreAuthProtocol = FirestoreAuth()
    
    // MARK: - Reset Password
    func resetPassword() async {
        guard !email.isEmpty else {
            self.error = .emptyEmail
            updateAlertState()
            return
        }
        
        do {
            try await firestoreAuth.resetPasswordFirebase(email: email)
            success = true
            self.error = nil
            updateAlertState()
        } catch {
            self.error = handleError(error)
            success = false
            updateAlertState()
        }
    }
    
    // MARK: - Alert
    func updateAlertState() {
        showAlert = error != nil || success
    }
    
    func getAlert() -> Alert {
        if success {
            return Alert(
                title: Text("Done"),
                message: Text("A password reset link has been sent to your email."),
                dismissButton: .default(Text("OK"))
            )
        } else {
            return Alert(
                title: Text("Error"),
                message: Text(error?.errorDescription ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
   
    // MARK: - Error
    private func handleError(_ error: Error) -> AuthError {
        let nsError = error as NSError
        if let authErrorCode = AuthErrorCode(rawValue: nsError.code) {
            switch authErrorCode {
            case .invalidEmail:
                return .invalidEmail
            case .networkError:
                return .networkError
            case .userNotFound:
                return .userNotFound
            default:
                return .unknownError
            }
        }
        return .unknownError
    }
}
