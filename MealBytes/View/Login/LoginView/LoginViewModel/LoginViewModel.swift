//
//  LoginViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/03/2025.
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
    @Published var isSignIn: Bool = false
    
    private var error: AuthError?
    
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    private let mainViewModel: MainViewModelProtocol
    private let goalsViewModel: GoalsViewModelProtocol
    
    init(
        mainViewModel: MainViewModelProtocol,
        goalsViewModel: GoalsViewModelProtocol
    ) {
        self.mainViewModel = mainViewModel
        self.goalsViewModel = goalsViewModel
    }
    
    // MARK: - Load Data
    func loadData() async {
        async let mainData: () = mainViewModel.loadMainData()
        async let loginData: () = loadLoginData()
        
        _ = await (mainData, loginData)
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    // MARK: - Load Login Data
    func loadLoginData() async {
        async let tokenTask: String? = firebaseAuth.refreshTokenAuth()
        async let authTask: Bool = firebaseAuth.checkCurrentUserAuth()
        
        do {
            let (_, isAuthenticated) = try await (tokenTask, authTask)
            let (email, isLoggedIn) = try await firestore
                .loadLoginDataFirestore()
            
            await MainActor.run {
                self.isLoggedIn = isAuthenticated && isLoggedIn
                self.email = email
            }
        } catch {
            do {
                let (email, isLoggedIn) = try await firestore
                    .loadLoginDataFirestore()
                
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
    }
    
    // MARK: - Sign In
    func signIn() async {
        await MainActor.run {
            isSignIn = true
        }
        
        do {
            let user = try await firebaseAuth.signInAuth(
                email: email,
                password: password
            )
            
            
            if !user.isEmailVerified {
                await MainActor.run {
                    self.error = .userNotVerified
                    self.isSignIn = false
                    updateAlertState()
                }
                return
            }
            
            do {
                try await firestore.saveLoginDataFirestore(
                    email: email,
                    isLoggedIn: true
                )
            } catch {
                await MainActor.run {
                    self.error = .networkError
                    self.isSignIn = false
                    updateAlertState()
                }
                return
            }
            
            await mainViewModel.loadMainData()
            
            await MainActor.run {
                self.error = nil
                self.isSignIn = false
                updateAlertState()
                isLoggedIn = true
                showErrorAlert = false
            }
        } catch {
            await MainActor.run {
                self.error = handleError(error as NSError)
                self.isSignIn = false
                updateAlertState()
            }
        }
    }
    
    var loginState: LoginState {
        switch true {
        case isSignIn: return .signingIn
        case isLoading: return .loadingLogo
        case isLoggedIn: return .loggedIn
        default: return .notLoggedIn
        }
    }
    
    // MARK: - Reset State
    func resetLoginState() {
        email = ""
        password = ""
        showAlert = false
        showErrorAlert = false
        isLoggedIn = false
        isSignIn = false
        error = nil
        
        mainViewModel.resetMainState()
        goalsViewModel.clearGoalsView()
    }
    
    // MARK: - Alert
    private func updateAlertState() {
        showAlert = error != nil
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
    
    func commonErrorAlert() -> Alert {
        return Alert(
            title: Text("Error"),
            message: Text("Something went wrong while processing the request. Try again."),
            dismissButton: .default(Text("OK"))
        )
    }
    
    func getSessionAlert(onDismiss: @escaping () -> Void) -> Alert {
        return Alert(
            title: Text("Session Expired"),
            message: Text(error?.errorDescription ?? ""),
            dismissButton: .default(Text("OK"), action: onDismiss)
        )
    }
    
    func getOfflineAlert() -> Alert {
        return Alert(
            title: Text("Warning!"),
            message: Text(error?.errorDescription ?? ""),
            dismissButton: .default(Text("OK"))
        )
    }
    
    var alertType: AlertTypeLoginView {
        switch error {
        case .sessionExpired: return .sessionExpired
        case .offlineMode: return .offlineMode
        default: return .generic
        }
    }
    
    // MARK: - Button State
    func isLoginEnabled() -> Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    // MARK: - Error
    private func handleError(_ error: NSError) -> AuthError {
        if let authErrorCode = AuthErrorCode(rawValue: error.code) {
            switch authErrorCode {
            case .invalidEmail: return .invalidEmail
            case .networkError: return .networkError
            case .userDisabled: return .userNotVerified
            default: return .incorrectCredentials
            }
        }
        return .unknownError
    }
}

enum LoginState {
    case loadingLogo
    case signingIn
    case loggedIn
    case notLoggedIn
}

enum AlertTypeLoginView {
    case sessionExpired
    case offlineMode
    case generic
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewLoginView.loginView
}
