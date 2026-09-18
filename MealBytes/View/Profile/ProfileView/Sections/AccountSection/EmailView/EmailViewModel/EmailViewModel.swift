//
//  EmailViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 10.09.2026.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class EmailViewModel: ObservableObject {
    @Published var alertType: EmailAlertType?
    @Published var newEmail: String = ""
    @Published var password: String = ""
    @Published var isSuccess: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: AuthError?
    
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    
    init(currentEmail: String = "") {
        self.newEmail = currentEmail
    }
    
    // MARK: - Change Email
    func changeEmail() async {
        guard isFormValid else { return }
        
        let cleanedEmail = newEmail
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        if let currentEmail = firebaseAuth.getCurrentUserEmail(),
           cleanedEmail == currentEmail {
            alertType = .error(
                title: "Error",
                message: AuthError.sameEmail.errorDescription ?? ""
            )
            return
        }
        
        alertType = .password
    }
    
    func confirmChangeEmail() async {
        guard isFormValid else { return }
        
        let cleanedEmail = newEmail
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
        
        isLoading = true
        
        defer {
            withAnimation {
                isLoading = false
            }
        }
        
        do {
            try await firebaseAuth.updateEmailAuth(
                newEmail: cleanedEmail,
                password: password
            )
            
            alertType = .success(
                title: "Done",
                message: "A verification link has been sent to email."
            )
            password = ""
        } catch {
            let error = handleEmailError(error as NSError)
            alertType = .error(
                title: "Error",
                message: error.errorDescription ?? "Failed to change email."
            )
        }
    }
    
    private func handleEmailError(_ nsError: NSError) -> AuthError {
        if let underlyingError = nsError
            .userInfo[NSUnderlyingErrorKey] as? NSError,
           let deserializedResponse = underlyingError.userInfo[
            "FIRAuthErrorUserInfoDeserializedResponseKey"
           ] as? [String: Any],
           let message = deserializedResponse["message"] as? String {
            
            switch message {
            case "INVALID_NEW_EMAIL": return .invalidEmail
            case "EMAIL_EXISTS": return .emailAlreadyInUse
            default: break
            }
        }
        
        if let authErrorCode = AuthErrorCode(rawValue: nsError.code) {
            switch authErrorCode {
            case .invalidEmail: return .invalidEmail
            case .emailAlreadyInUse: return .emailAlreadyInUse
            case .networkError: return .networkError
            case .wrongPassword: return .incorrectCredentials
            case .requiresRecentLogin: return .sessionExpired
            default: return .unknownError
            }
        }
        return .unknownError
    }
    
    // MARK: - Alert
    var alertTitle: String {
        switch alertType {
        case .password: return "Enter Current Password"
        case .error(let title, _): return title
        case .success(let title, _): return title
        case .none: return ""
        }
    }
    
    var alertMessage: String {
        switch alertType {
        case .password: return "A verification link will be sent to confirm the change."
        case .error(_, let message): return message
        case .success(_, let message): return message
        case .none: return ""
        }
    }
    
    // MARK: - UI Helper
    var isFormValid: Bool {
        !newEmail.isEmpty
    }
    
    enum EmailAlertType {
        case password
        case error(title: String, message: String)
        case success(title: String, message: String)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewProfileView.profileView
}
