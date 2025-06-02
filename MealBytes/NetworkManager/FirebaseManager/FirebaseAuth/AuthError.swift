//
//  AuthError.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 29/03/2025.
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
            "The entered email address is invalid. Check and try again."
        case .incorrectCredentials:
            "Incorrect email or password. Check and try again."
        case .emailAlreadyInUse:
            "The email address is already in use."
        case .userNotFound:
            "No user found with the specified email address."
        case .userNotVerified:
            """
            Email is not verified.
            Check the inbox and verify the email address.
            """
        case .weakPassword:
            "The password must be at least 6 characters long."
        case .networkError:
            """
            A network error occurred.
            Check the internet connection and try again.
            """
        case .sessionExpired:
            """
            You have been disconnected.
            Log in again to restore access and continue.
            """
        case .offlineMode:
            """
            You are offline.
            Local changes are saved and will sync automatically when the network connection is restored.
            """
        case .unknownError:
            "Something went wrong while processing the request. Try again."
        }
    }
}
