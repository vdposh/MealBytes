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
        }
    }
//    
//    @ViewBuilder
//    func contentUnavailableView(query: String, action: @escaping ()
//                                -> Void) -> some View {
//        ContentUnavailableView {
//            switch self {
//            case .network:
//                Label {
//                    Text("Network error")
//                } icon: {
//                    Image(systemName: "wifi.slash")
//                }
//                .symbolEffect(.pulse)
//            case .decoding:
//                Label {
//                    Text("Data processing issue")
//                } icon: {
//                    Image(systemName: "exclamationmark.triangle")
//                }
//                .symbolEffect(.rotate, options: .nonRepeating)
//            case .results:
//                ContentUnavailableView.search(text: query)
//            case .noBookmarks:
//                Label {
//                    Text("No bookmarks yet")
//                } icon: {
//                    Image(systemName: "bookmark")
//                }
//            }
//        } description: {
//            switch self {
//            case .noBookmarks:
//                Text("Add your favorite dishes to bookmarks, and they'll appear here.")
//            default:
//                Text(errorDescription)
//            }
//        } actions: {
//            if case .network = self {
//                Button("Refresh", action: action)
//            }
//        }
//    }
}
