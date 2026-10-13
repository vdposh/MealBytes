//
//  PasswordViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 09.09.2026.
//

import SwiftUI
import FirebaseAuth

final class PasswordViewModel: ObservableObject {
    @Published var currentPassword: String = ""
    @Published var newPassword: String = ""
    @Published var confirmPassword: String = ""
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var isSuccess: Bool = false
    @Published var isLoading: Bool = false
    
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    
    // MARK: - Change Password
    func changePassword() async {
        guard isFormValid else { return }
        
        if let errorMessage = validatePassword() {
            await MainActor.run {
                showErrorAlert(errorMessage)
            }
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
            try await firebaseAuth.changePasswordAuth(
                currentPassword: currentPassword,
                newPassword: newPassword
            )
            
            await MainActor.run {
                isSuccess = true
                alertTitle = "Done"
                alertMessage = "Password has been successfully updated."
                showAlert = true
            }
            
        } catch {
            let errorMessage = handlePasswordError(
                error as NSError
            ).errorDescription ?? "Failed to update password."
            
            await MainActor.run {
                isSuccess = false
                showErrorAlert(errorMessage)
            }
        }
    }
    
    private func validatePassword() -> String? {
        if newPassword != confirmPassword {
            return AuthError.passwordMismatch.errorDescription
        }
        
        if newPassword.count < 6 {
            return AuthError.weakPassword.errorDescription
        }
        
        return nil
    }
    
    private func handlePasswordError(_ nsError: NSError) -> AuthError {
        if let authErrorCode = AuthErrorCode(rawValue: nsError.code) {
            switch authErrorCode {
            case .weakPassword: return .weakPassword
            case .networkError: return .networkError
            case .wrongPassword: return .incorrectCurrentPassword
            case .invalidCredential: return .incorrectCurrentPassword
            default: return .unknownError
            }
        }
        return .unknownError
    }
    
    func resetPasswordState() {
        currentPassword = ""
        newPassword = ""
        confirmPassword = ""
    }
    
    // MARK: - UI Helper
    var isFormValid: Bool {
        !currentPassword.isEmpty &&
        !newPassword.isEmpty &&
        !confirmPassword.isEmpty
    }
    
    private func showErrorAlert(_ message: String) {
        alertTitle = "Error"
        alertMessage = message
        showAlert = true
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewProfileView.profileView
}

#Preview {
    NavigationStack {
        PasswordView()
    }
}
