//
//  AppError.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

enum AppError: Error, Identifiable, LocalizedError {
    var id: UUID {
        UUID()
    }
    
    case network
    case decoding
    case results
    case noBookmarks
    case disconnected
    
    var errorDescription: String {
        switch self {
        case .network:
            "There was a problem connecting to the network. Please check your internet connection and try again."
        case .decoding:
            "There was a problem reading the data. Please ensure everything is correct and try again."
        case .results:
            ""
        case .noBookmarks:
            "No bookmarks yet"
        case .disconnected:
            "Your account is disconnected. Please log out and log back in to sync your data."
        }
    }
}
