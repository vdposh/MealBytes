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
    @Published var success: Bool = false
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    
    private var error: AuthError?
    
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    
    // MARK: - Reset Password
    func resetPassword() async {
        guard isResetEnabled() else { return }
        
        let cleanedEmail = email
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        guard cleanedEmail.isValidEmail else {
            await handleResetResult(success: false, error: .invalidEmail)
            return
        }
        
        await MainActor.run {
            isLoading = true
        }
        
        defer {
            Task { @MainActor in
                withAnimation {
                    isLoading = false
                }
            }
        }
        
        do {
            try await firebaseAuth.resetPasswordAuth(email: cleanedEmail)
            await handleResetResult(success: true, error: nil)
        } catch {
            await handleResetResult(
                success: false,
                error: handleResetError(error as NSError)
            )
        }
    }
    
    private func handleResetResult(success: Bool, error: AuthError?) async {
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
                message: Text("Password reset link sent to email."),
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
        !email.isEmpty
    }
    
    // MARK: - Error
    private func handleResetError(_ nsError: NSError) -> AuthError {
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

#Preview {
    NavigationStack {
        ResetView()
    }
}
