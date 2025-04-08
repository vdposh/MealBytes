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
    @Published var isAuthenticated: Bool = false
    @Published var showAlert: Bool = false
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = true
    
    private var error: AuthError?
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    private let networkMonitor = NetworkMonitor()
    
    init() {
        Task {
            await loadLoginData()
        }
    }
    
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
                isAuthenticated = true
                self.error = nil
                self.isLoading = false
                updateAlertState()
                isLoggedIn = true
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
        isLoading = true
        await networkMonitor.waitForConnectionUpdate()
        
        if networkMonitor.isConnected == true {
            async let tokenTask: String? = firebaseAuth.refreshTokenAuth()
            async let authTask: Bool = firebaseAuth.checkCurrentUserAuth()
            
            do {
                let (_, isAuthenticated) = try await (tokenTask, authTask)
                
                do {
                    let (email, isLoggedIn) = try await firestore
                        .loadLoginDataFirestore()
                    await MainActor.run {
                        self.isLoggedIn = isAuthenticated && isLoggedIn
                        self.email = email
                    }
                } catch {
                    await MainActor.run {
                        self.error = .networkError
                        updateAlertState()
                    }
                }
            } catch {
                await MainActor.run {
                    self.isLoggedIn = false
                }
            }
        } else {
            do {
                let (email, isLoggedIn) = try await firestore
                    .loadLoginDataFirestore()
                await MainActor.run {
                    self.isLoggedIn = isLoggedIn
                    self.email = email
                    self.password = ""
                }
            } catch {
                await MainActor.run {
                    self.error = .networkError
                    updateAlertState()
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
