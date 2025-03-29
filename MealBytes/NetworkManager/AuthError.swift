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
    
    case emptyFields
    case emptyEmail
    case emptyPassword
    case invalidEmail
    case incorrectCredentials
    case networkError
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .emptyFields:
            "Please enter your email and password."
        case .emptyEmail:
            "Please enter your email address."
        case .emptyPassword:
            "Please enter your password."
        case .invalidEmail:
            "The email address entered is invalid. Please check and try again."
        case .incorrectCredentials:
            "Incorrect email or password. Please try again."
        case .networkError:
            "A network error occurred. Please check your internet connection and try again."
        case .unknownError:
            "An unknown error occurred. Please try again later."
        }
    }
}
