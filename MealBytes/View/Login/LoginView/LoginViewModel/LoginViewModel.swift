//
//  LoginViewModel.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI
import FirebaseAuth

final class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: AuthError?
    @Published var isAuthenticated: Bool = false
    @Published var showAlert = false
    @Published var isLoggedIn: Bool = false
    
    var setMainViewLoading: (() -> Void)?
    
    let registerView = RegisterView()
    let resetView = ResetView()
    private let firestoreAuth: FirestoreAuthProtocol = FirestoreAuth()
    
    init() {
        if firestoreAuth.isCurrentUserEmailVerified() {
            isLoggedIn = true
        }
    }
    
    // MARK: - Sign In
    func signIn() async {
        do {
            let user = try await firestoreAuth.signInFirebase(
                email: email,
                password: password
            )
            
            if !user.isEmailVerified {
                await MainActor.run {
                    self.error = .userNotVerified
                    updateAlertState()
                }
                return
            }
            
            await MainActor.run {
                isAuthenticated = true
                self.error = nil
                updateAlertState()
                isLoggedIn = true
                setMainViewLoading?()
            }
        } catch {
            await MainActor.run {
                self.error = handleError(error as NSError)
                updateAlertState()
            }
        }
    }
    
    // MARK: - Alert
    private func updateAlertState() {
        Task {
            await MainActor.run {
                showAlert = error != nil
            }
        }
    }
    
    func getAlert() -> Alert {
        if let error {
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
    
    // MARK: - Button State
    func isLoginEnabled() -> Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    // MARK: - Colors
    func titleColor(for text: String) -> Color {
        return text.isEmpty ? .customRed : .primary
    }
    
    // MARK: - Error
    private func handleError(_ error: NSError) -> AuthError {
        if let authErrorCode = AuthErrorCode(rawValue: error.code) {
            switch authErrorCode {
            case .invalidEmail:
                return .invalidEmail
            case .networkError:
                return .networkError
            case .userDisabled:
                return .userNotVerified
            default:
                return .incorrectCredentials
            }
        }
        return .unknownError
    }
}
