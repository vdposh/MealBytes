//
//  FirebaseAuth.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI
import FirebaseAuth

protocol FirestoreAuthProtocol {
    func signInFirebase(email: String, password: String) async throws -> User
    func isCurrentUserEmailVerified() -> Bool
    func signUpFirebase(email: String, password: String) async throws
    func reauthenticateFirebase(email: String, password: String) async throws
    func resetPasswordFirebase(email: String) async throws
    func signOutFirebase() throws
    func deleteAccountFirebase() async throws
    func resendVerificationFirebase() async throws
}

final class FirestoreAuth: FirestoreAuthProtocol {
    // MARK: - Sign In
    func signInFirebase(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email,
                                                  password: password)
        return result.user
    }
    
    // MARK: - Sign Up
    func signUpFirebase(email: String, password: String) async throws {
        let result = try await Auth.auth().createUser(withEmail: email,
                                                      password: password)
        try await result.user.sendEmailVerification()
    }
    
    // MARK: - Resend Verification
    func resendVerificationFirebase() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        try await user.sendEmailVerification()
    }
    
    // MARK: - Reset Password
    func resetPasswordFirebase(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    // MARK: - Sign Out
    func signOutFirebase() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Delete Account
    func deleteAccountFirebase() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        try await user.delete()
    }
    
    func reauthenticateFirebase(email: String,
                                password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        let credential = EmailAuthProvider.credential(withEmail: email,
                                                      password: password)
        try await user.reauthenticate(with: credential)
    }
    
    // MARK: - Current User
    func isCurrentUserEmailVerified() -> Bool {
        guard let user = Auth.auth().currentUser else {
            return false
        }
        return user.isEmailVerified
    }
}
