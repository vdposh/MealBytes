//
//  ResetViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/03/2025.
//

import SwiftUI
import FirebaseAuth

final class ResetViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var sentEmail: String = ""
    @Published var success: Bool = false
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var isEmailSent = false
    
    private var error: AuthError?
    
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    
    // MARK: - Reset Password
    func resetPassword() async {
        await MainActor.run {
            isLoading = true
        }
        
        do {
            try await firebaseAuth.resetPasswordAuth(email: email)
            await MainActor.run {
                isEmailSent = true
                sentEmail = email
            }
            await handleResult(success: true, error: nil)
        } catch {
            await handleResult(
                success: false,
                error: handleError(error as NSError)
            )
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    private func handleResult(success: Bool, error: AuthError?) async {
        await MainActor.run {
            self.success = success
            self.error = error
            updateAlertState()
        }
    }
    
    // MARK: - Alert
    private func updateAlertState() {
        showAlert = error != nil || success
    }
    
    func getAlert() -> Alert {
        if success {
            return Alert(
                title: Text("Done"),
                message: Text("A reset link for the password has been sent to the email."),
                dismissButton: .default(Text("OK"))
            )
        } else {
            return Alert(
                title: Text("Error"),
                message: Text(error?.errorDescription ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Button State
    func isResetEnabled() -> Bool {
        return !email.isEmpty
    }
    
    // MARK: - Color
    func titleColor(for text: String) -> Color {
        return text.isEmpty ? .customRed : .secondary
    }
    
    // MARK: - Error
    private func handleError(_ nsError: NSError) -> AuthError {
        if let authErrorCode = AuthErrorCode(rawValue: nsError.code) {
            switch authErrorCode {
            case .invalidEmail: return .invalidEmail
            case .networkError: return .networkError
            default: return .unknownError
            }
        }
        return .unknownError
    }
}
