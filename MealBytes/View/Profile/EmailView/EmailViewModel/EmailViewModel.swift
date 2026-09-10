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
    @Published var newEmail: String = ""
    @Published var showAlert: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    @Published var isSuccess: Bool = false
    @Published var isLoading: Bool = false
    
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    
    init(currentEmail: String = "") {
        self.newEmail = currentEmail
    }
    
    // MARK: - Change Email
    func changeEmail() async {
        guard isFormValid else { return }
        
        isLoading = true
        
        defer {
            withAnimation {
                isLoading = false
            }
        }
        
        do {
            try await firebaseAuth.updateEmailAuth(newEmail: newEmail)
            
            isSuccess = true
            alertTitle = "Done"
            alertMessage = "A verification link has been sent to email. Follow it to complete the email change."
            showAlert = true
        } catch {
            isSuccess = false
            alertTitle = "Error"
            alertMessage = handleEmailError(
                error as NSError
            ).errorDescription ?? "Failed to change email."
            showAlert = true
        }
    }
    
    private func handleEmailError(_ nsError: NSError) -> AuthError {
        if let authErrorCode = AuthErrorCode(rawValue: nsError.code) {
            switch authErrorCode {
            case .invalidEmail: return .invalidEmail
            case .emailAlreadyInUse: return .emailAlreadyInUse
            case .networkError: return .networkError
            default: return .unknownError
            }
        }
        return .unknownError
    }
    
    // MARK: - UI Helper
    var isFormValid: Bool {
        !newEmail.isEmpty
    }
}
#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewProfileView.profileView
}
