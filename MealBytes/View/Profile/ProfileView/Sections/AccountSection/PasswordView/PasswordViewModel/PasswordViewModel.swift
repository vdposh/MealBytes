//
//  PasswordViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 09.09.2026.
//

import SwiftUI
import FirebaseAuth

@MainActor
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
            alertTitle = "Error"
            alertMessage = errorMessage
            showAlert = true
            return
        }
        
        isLoading = true
        
        defer {
            withAnimation {
                isLoading = false
            }
        }
        
        do {
            try await firebaseAuth.changePasswordAuth(
                currentPassword: currentPassword,
                newPassword: newPassword
            )
            
            isSuccess = true
            alertTitle = "Done"
            alertMessage = "Password has been successfully updated."
            showAlert = true
            
        } catch {
            isSuccess = false
            alertTitle = "Error"
            alertMessage = handlePasswordError(
                error as NSError
            ).errorDescription ?? "Failed to update password."
            showAlert = true
        }
    }
    
    private func validatePassword() -> String? {
        if newPassword != confirmPassword {
            return "New password and confirmation do not match."
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
        showAlert = false
        isSuccess = false
    }
    
    // MARK: - UI Helper
    var isFormValid: Bool {
        !currentPassword.isEmpty &&
        !newPassword.isEmpty &&
        !confirmPassword.isEmpty
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
