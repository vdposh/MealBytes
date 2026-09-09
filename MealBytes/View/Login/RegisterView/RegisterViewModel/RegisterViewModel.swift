//
//  RegisterViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/03/2025.
//

import SwiftUI
import Combine
import FirebaseAuth

final class RegisterViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var timerText: String = ""
    @Published var showAlert: Bool = false
    @Published var isResendEnabled: Bool = false
    @Published var showResendOptions: Bool = false
    @Published var isRegisterLoading: Bool = false
    
    private var error: AuthError?
    private var remainingSeconds: Int = 60
    
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    private var timerSubscription: AnyCancellable?
    
    deinit {
        timerSubscription?.cancel()
    }
    
    // MARK: - Sign Up
    func signUp() async {
        await MainActor.run {
            isRegisterLoading = true
        }
        
        defer {
            Task { @MainActor in
                withAnimation {
                    isRegisterLoading = false
                }
            }
        }
        
        guard password == confirmPassword else {
            await handleSignUpResult(success: false, error: .passwordMismatch)
            return
        }
        
        do {
            try await firebaseAuth.signUpAuth(
                email: email,
                password: password
            )
            
            await handleSignUpResult(success: true)
            await MainActor.run {
                showResendOptions = true
            }
            await startResendTimer()
        } catch {
            let authError = handleRegisterError(error as NSError)
            await handleSignUpResult(success: false, error: authError)
        }
    }
    
    // MARK: - Resend Email Verification
    func resendEmailVerification() async {
        guard isResendEnabled else { return }
        
        await MainActor.run {
            isRegisterLoading = true
        }
        
        do {
            try await firebaseAuth.resendVerificationAuth()
            
            await startResendTimer()
        } catch {
            let authError = handleRegisterError(error as NSError)
            
            await MainActor.run {
                self.error = authError
            }
        }
        
        await MainActor.run {
            withAnimation {
                isRegisterLoading = false
            }
        }
    }
    
    // MARK: - Timer for Resend
    private func startResendTimer() async {
        await MainActor.run {
            isResendEnabled = false
            remainingSeconds = 60
            updateTimerText()
        }
        
        timerSubscription?.cancel()
        timerSubscription = Timer.publish(
            every: 1.0,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { [weak self] _ in
            guard let self else { return }
            
            self.remainingSeconds -= 1
            
            self.updateTimerText()
            
            if self.remainingSeconds <= 0 {
                self.timerSubscription?.cancel()
                
                withAnimation {
                    self.isResendEnabled = true
                }
            }
        }
    }
    
    private func updateTimerText() {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        
        timerText = String(format: "%02d:%02d", minutes, seconds)
    }
    
    // MARK: - Alert
    func getAlert() -> Alert {
        if let error {
            return Alert(
                title: Text("Error"),
                message: Text(error.errorDescription ?? ""),
                dismissButton: .default(Text("OK"))
            )
        } else {
            return Alert(
                title: Text("Done"),
                message: Text("A confirmation email has been sent"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func handleSignUpResult(
        success: Bool,
        error: AuthError? = nil
    ) async {
        await MainActor.run {
            self.error = error
            showAlert = true
        }
    }
    
    // MARK: - Button State
    func isRegisterEnabled() -> Bool {
        return !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty
    }
    
    // MARK: - Error
    private func handleRegisterError(_ nsError: NSError) -> AuthError {
        if let authErrorCode = AuthErrorCode(rawValue: nsError.code) {
            switch authErrorCode {
            case .invalidEmail: return .invalidEmail
            case .emailAlreadyInUse: return .emailAlreadyInUse
            case .weakPassword: return .weakPassword
            case .networkError: return .networkError
            default: return .unknownError
            }
        }
        
        return .unknownError
    }
    
    // MARK: - UI Helper
    var registerState: RegisterState {
        if isRegisterLoading {
            return .loading
        } else if showResendOptions {
            return .resend
        } else {
            return .register
        }
    }
    
    enum RegisterState {
        case loading
        case resend
        case register
    }
}

#Preview {
    NavigationStack {
        RegisterView()
    }
}
