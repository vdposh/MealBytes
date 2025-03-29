//
//  FirestoreAuth.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI
import FirebaseAuth

protocol FirestoreAuthProtocol {
    func signInFirebase(email: String, password: String) async throws -> User
    func signUpFirebase(email: String, password: String) async throws -> User
    func signOutFirebase() throws
    func deleteAccountFirebase() async throws
    func resetPasswordFirebase(email: String) async throws
}

final class FirestoreAuth: FirestoreAuthProtocol {
    // MARK: - Sign In
    func signInFirebase(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email,
                                                  password: password)
        return result.user
    }
    
    // MARK: - Sign Up
    func signUpFirebase(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().createUser(withEmail: email,
                                                      password: password)
        return result.user
    }
    
    // MARK: - Sign Out
    func signOutFirebase() throws {
        try Auth.auth().signOut()
    }
    
    // MARK: - Delete Account
    func deleteAccountFirebase() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthenticationError.userNotFound
        }
        try await user.delete()
    }
    
    // MARK: - Reset Password
    func resetPasswordFirebase(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    enum AuthenticationError: Error {
        case userNotFound
    }
}
