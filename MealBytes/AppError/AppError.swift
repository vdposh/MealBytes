//
//  AppError.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

enum AppError: Error, Identifiable, LocalizedError, Equatable {
    var id: UUID {
        UUID()
    }
    
    case network
    case networkRefresh
    case decoding
    case results
    case noBookmarks
    case disconnected
    
    var errorDescription: String {
        switch self {
        case .network, .networkRefresh:
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
