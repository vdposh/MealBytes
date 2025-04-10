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
    @Published var showAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = true
    
    private var error: AuthError?
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    
    // MARK: - Sign In
    func signIn() async {
        await MainActor.run {
            isLoading = true
        }
        
        do {
            let user = try await firebaseAuth.signInAuth(email: email,
                                                         password: password)
            
            if !user.isEmailVerified {
                await MainActor.run {
                    self.error = .userNotVerified
                    self.isLoading = false
                    updateAlertState()
                }
                return
            }
            
            do {
                try await firestore.saveLoginDataFirestore(email: email,
                                                           isLoggedIn: true)
            } catch {
                await MainActor.run {
                    self.error = .networkError
                    self.isLoading = false
                    updateAlertState()
                }
                return
            }
            
            await MainActor.run {
                self.error = nil
                self.isLoading = false
                updateAlertState()
                isLoggedIn = true
                showErrorAlert = false
            }
        } catch {
            await MainActor.run {
                self.error = handleError(error as NSError)
                self.isLoading = false
                updateAlertState()
            }
        }
    }
    
    // MARK: - Load Data
    func loadLoginData() async {
        async let tokenTask: String? = firebaseAuth.refreshTokenAuth()
        async let authTask: Bool = firebaseAuth.checkCurrentUserAuth()
        
        do {
            let (_, isAuthenticated) = try await (tokenTask, authTask)
            let (email,
                 isLoggedIn) = try await firestore.loadLoginDataFirestore()
            
            await MainActor.run {
                self.isLoggedIn = isAuthenticated && isLoggedIn
                self.email = email
            }
        } catch {
            do {
                let (email,
                     isLoggedIn) = try await firestore.loadLoginDataFirestore()
                
                await MainActor.run {
                    self.email = email
                    self.isLoggedIn = isLoggedIn
                    self.error = .offlineMode
                    self.showErrorAlert = true
                }
            } catch {
                await MainActor.run {
                    self.error = .sessionExpired
                    self.showErrorAlert = true
                }
            }
            
        }
        
        await MainActor.run {
            isLoading = false
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
    
    func getErrorAlert() -> Alert {
        if let error {
            switch error {
                
            case .offlineMode:
                return Alert(
                    title: Text("Warning!"),
                    message: Text(error.errorDescription ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            case .sessionExpired:
                return Alert(
                    title: Text("Session Expired"),
                    message: Text(error.errorDescription ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            case .unknownError:
                return Alert(
                    title: Text("Error"),
                    message: Text(error.errorDescription ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            default:
                return commonErrorAlert()
            }
        } else {
            return commonErrorAlert()
        }
    }
    
    func getLoginErrorAlert() -> Alert {
        if let error {
            switch error {
            case .userNotVerified:
                return Alert(
                    title: Text("Verification Error"),
                    message: Text(error.errorDescription ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            case .networkError:
                return Alert(
                    title: Text("Network Error"),
                    message: Text(error.errorDescription ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            default:
                return Alert(
                    title: Text("Error"),
                    message: Text(error.errorDescription ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        } else {
            return commonErrorAlert()
        }
    }
    
    private func commonErrorAlert() -> Alert {
        return Alert(
            title: Text("Error"),
            message: Text("Something went wrong while processing your request. Please try again in a moment."),
            dismissButton: .default(Text("OK"))
        )
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
