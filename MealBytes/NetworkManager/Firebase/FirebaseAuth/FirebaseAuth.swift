//
//  FirebaseAuth.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI
import FirebaseAuth

protocol FirebaseAuthProtocol {
    func signInAuth(email: String, password: String) async throws -> User
    func refreshTokenAuth() async throws -> String
    func checkCurrentUserAuth() -> Bool
    func signUpAuth(email: String, password: String) async throws
    func reauthenticateAuth(email: String, password: String) async throws
    func resetPasswordAuth(email: String) async throws
    func signOutAuth() throws
    func deleteAccountAuth() async throws
    func resendVerificationAuth() async throws
    func changePasswordAuth(currentPassword: String,
                            newPassword: String) async throws
}

final class FirebaseAuth: FirebaseAuthProtocol {
    // MARK: - Sign In
    func signInAuth(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email,
                                                  password: password)
        return result.user
    }
    
    // MARK: - Sign Up
    func signUpAuth(email: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email,
                                                      password: password)
        try await result.user.sendEmailVerification()
    }
    
    // MARK: - Resend Verification
    func resendVerificationAuth() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        try await user.sendEmailVerification()
    }
    
    // MARK: - Reset Password
    func resetPasswordAuth(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // MARK: - Sign Out
    func signOutAuth() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Delete Account
    func deleteAccountAuth() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        try await user.delete()
    }
    
    func reauthenticateAuth(email: String,
                            password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        let credential = EmailAuthProvider.credential(withEmail: email,
                                                      password: password)
        try await user.reauthenticate(with: credential)
    }
    
    // MARK: - Change Password
    func changePasswordAuth(currentPassword: String,
                            newPassword: String) async throws {
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            throw AuthError.userNotFound
        }
        let credential = EmailAuthProvider.credential(withEmail: email,
                                                      password: currentPassword)
        try await user.reauthenticate(with: credential)
        try await user.updatePassword(to: newPassword)
    }
    
    // MARK: - Current User
    func checkCurrentUserAuth() -> Bool {
        guard let user = Auth.auth().currentUser else {
            return false
        }
        return user.isEmailVerified
    }
    
    func refreshTokenAuth() async throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            user.getIDTokenForcingRefresh(true) { token, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let token = token {
                    continuation.resume(returning: token)
                } else {
                    continuation.resume(throwing: AuthError.unknownError)
                }
            }
        }
    }
}
