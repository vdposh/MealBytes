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
            """
            Unable to connect to the network.
            Ensure internet access and try again.
            """
        case .decoding:
            "There was a problem reading the data. Ensure your connection is stable and try again later."
        case .results:
            ""
        case .noBookmarks:
            "No bookmarks yet"
        case .disconnected:
            "Account disconnected. Log out and log back in to restore data sync."
        }
    }
}
