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
    
    var title: String {
        switch self {
        case .signOut: return "Sign Out"
        case .deleteAccount: return "Delete Account"
        }
    }
    
    var destructiveTitle: String {
        switch self {
        case .signOut: return "Sign Out"
        case .deleteAccount: return "Delete Account"
        }
    }
    
    var defaultMessage: String {
        switch self {
        case .signOut:
            return "Signing out will require signing in again to access the account."
        case .deleteAccount:
            return "Data and account details will be permanently erased. This action cannot be undone."
        }
    }
}
