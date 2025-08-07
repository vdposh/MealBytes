//
//  AlertContentProfile.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07/08/2025.
//

import SwiftUI

struct AlertContentProfile: Identifiable {
    let type: AlertTypeProfileView
    let overrideMessage: String?
    let isSuccess: Bool
    
    var id: UUID { UUID() }
    
    var title: String {
        isSuccess ? "Done" : type.title
    }
    
    var message: String {
        overrideMessage ?? type.defaultMessage
    }
    
    var destructiveTitle: String {
        type.destructiveTitle
    }
    
    init(
        type: AlertTypeProfileView,
        overrideMessage: String? = nil,
        isSuccess: Bool = false
    ) {
        self.type = type
        self.overrideMessage = overrideMessage
        self.isSuccess = isSuccess
    }
}

enum AlertTypeProfileView {
    case signOut
    case deleteAccount
    case changePassword
    
    var title: String {
        switch self {
        case .signOut: return "Sign Out"
        case .deleteAccount: return "Delete Account"
        case .changePassword: return "Change Password"
        }
    }
    
    var destructiveTitle: String {
        switch self {
        case .signOut: return "Sign Out"
        case .deleteAccount: return "Delete"
        case .changePassword: return "Update Password"
        }
    }
    
    var defaultMessage: String {
        switch self {
        case .signOut:
            return "Signing out will require signing in again to access the account."
        case .deleteAccount:
            return """
            To delete the account, enter the password associated with it.
            Data and account details will be permanently erased. This action cannot be undone.
            """
        case .changePassword:
            return "Provide the current password and a new password to update account credentials."
        }
    }
}

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
