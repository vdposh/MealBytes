//
//  LoginViewModel.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI
import FirebaseAuth

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var navigationDestination: NavigationDestination = .none
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var error: AuthError?
    @Published var isAuthenticated: Bool = false
    @Published var showAlert = false
    @Published var isLoggedIn: Bool = false
    
    let registerView = RegisterView()
    let resetView = ResetView()
    private let firestoreAuth: FirestoreAuthProtocol = FirestoreAuth()
    
    init() {
        if let user = Auth.auth().currentUser, user.isEmailVerified {
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
                self.error = .userNotVerified
                updateAlertState()
                return
            }
            
            isAuthenticated = true
            self.error = nil
            updateAlertState()
            isLoggedIn = true
        } catch {
            self.error = handleError(error as NSError)
            updateAlertState()
        }
    }
    
    // MARK: - Alert
    func updateAlertState() {
        showAlert = error != nil
    }
    
    func getAlert() -> Alert {
        if let error = error {
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
    
    // MARK: - Navigation
    enum NavigationDestination {
        case registerView
        case resetView
        case none
    }
}
