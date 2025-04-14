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
    case sessionExpired
    case offlineMode
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
            """
            Your email is not verified.
            Please check your inbox and verify your email address.
            """
        case .weakPassword:
            "The password must be at least 6 characters long."
        case .networkError:
            """
            A network error occurred. 
            Please check your internet connection and try again.
            """
        case .sessionExpired:
            """
            You have been disconnected.
            Please log in again to regain access and continue.
            """
        case .offlineMode:
            """
            You are offline.
            Local changes are saved and will sync automatically when the network connection is restored.
            """
        case .unknownError:
            "Something went wrong while processing your request. Please try again in a moment."
        }
    }
}
