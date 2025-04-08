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
    case emailAlreadyInUse
    case userNotFound
    case userNotVerified
    case weakPassword
    case networkError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            "The email address entered is invalid. Please check and try again."
        case .incorrectCredentials:
            "Incorrect email or password. Please try again."
        case .emailAlreadyInUse:
            "The email address is already in use. Please try another one."
        case .userNotFound:
            "No user found with the specified email address."
        case .userNotVerified:
            "Your email is not verified. Please check your inbox and verify your email address."
        case .weakPassword:
            "The password must be at least 6 characters long."
        case .networkError:
            "A network error occurred. Please check your internet connection and try again."
        case .unknownError:
            "An unknown error occurred. Please try again later."
        }
    }
}
