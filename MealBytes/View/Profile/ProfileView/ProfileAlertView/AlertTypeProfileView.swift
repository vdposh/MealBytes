//
//  AlertTypeProfileView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07/08/2025.
//

import SwiftUI

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
