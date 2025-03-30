//
//  AuthError.swift
//  MealBytes
//
//  Created by Porshe on 29/03/2025.
//

import SwiftUI

enum AuthError: Error, Identifiable, LocalizedError {
    var id: UUID {
        UUID()
    }
    
    case invalidEmail
    case incorrectCredentials
    case networkError
    case unknownError
    case emailAlreadyInUse
    case userNotFound
    case userNotVerified
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            "The email address entered is invalid. Please check and try again."
        case .incorrectCredentials:
            "Incorrect email or password. Please try again."
        case .networkError:
            "A network error occurred. Please check your internet connection and try again."
        case .unknownError:
            "An unknown error occurred. Please try again later."
        case .emailAlreadyInUse:
            "The email address is already in use. Please try another one."
        case .userNotFound:
            "No user found with the specified email address."
        case .userNotVerified:
            "Your email is not verified. Please check your inbox and verify your email address."
        }
    }
}
