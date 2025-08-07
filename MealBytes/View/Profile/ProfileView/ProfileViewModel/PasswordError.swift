//
//  PasswordError.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07/08/2025.
//

import SwiftUI

enum PasswordError: Error {
    case tooShort
    case mismatch
    
    var message: String {
        switch self {
        case .tooShort:
            return ProfileMessage.passwordTooShort.text
        case .mismatch:
            return ProfileMessage.passwordMismatch.text
        }
    }
}
