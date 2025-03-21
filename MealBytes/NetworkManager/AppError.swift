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
    
    case networkError
    case decodingError
    case noResults
    
    var errorDescription: String {
        switch self {
        case .networkError:
            "There was a problem connecting to the network. Please check your internet connection and try again."
        case .decodingError:
            "There was a problem decoding the data. Please ensure the data format is correct and try again."
        case .noResults:
            ""
        }
    }
    
    @ViewBuilder
    func contentUnavailableView(query: String, action: @escaping ()
                                -> Void) -> some View {
        ContentUnavailableView {
            switch self {
            case .networkError:
                Label {
                    Text("Network Error")
                } icon: {
                    Image(systemName: "wifi.slash")
                        .foregroundColor(.customGreen.opacity(0.6))
                }
                .symbolEffect(.pulse)
            case .decodingError:
                Label {
                    Text("Decoding Error")
                } icon: {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.customGreen.opacity(0.6))
                }
                .symbolEffect(.rotate, options: .nonRepeating)
            case .noResults:
                ContentUnavailableView.search(text: query)
            }
        } description: {
            Text(errorDescription)
        } actions: {
            if case .networkError = self {
                Button("Refresh", action: action)
            }
        }
    }
}
