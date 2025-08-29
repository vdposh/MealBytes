//
//  ProfileMessage.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07/08/2025.
//

import SwiftUI

enum ProfileMessage {
    case passwordTooShort
    case passwordMismatch
    case incorrectPassword
    case emailMissing
    case passwordUpdateFailed
    case passwordUpdateSuccess
    
    var text: String {
        switch self {
        case .passwordTooShort:
            return """
            Failed to update the password.
            The password must be at least 6 characters long.
            """
        case .passwordMismatch:
            return """
            Failed to update the password.
            New password and confirmation do not match.
            """
        case .incorrectPassword:
            return """
            The password entered is incorrect.
            To delete the account, provide the correct password.
            """
        case .emailMissing:
            return "Email is missing."
        case .passwordUpdateFailed:
            return """
            Failed to update the password.
            Check the current password and try again.
            """
        case .passwordUpdateSuccess:
            return "Password has been successfully updated."
        }
    }
}
