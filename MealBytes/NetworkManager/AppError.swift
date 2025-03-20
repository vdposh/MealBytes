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
    
    case invalidID
    case networkError
    case decodingError
    
    var errorDescription: String {
        switch self {
        case .invalidID:
            "The ID provided is not valid. Please check and try again."
        case .networkError:
            "There was a problem connecting to the network. Please check your internet connection and try again."
        case .decodingError:
            "There was a problem decoding the data. Please ensure the data format is correct and try again."
        }
    }
    
    @ViewBuilder
    func contentUnavailableView(action: @escaping () -> Void) -> some View {
        ContentUnavailableView {
            switch self {
            case .networkError:
                Label {
                    Text("Network Error")
                } icon: {
                    Image(systemName: "wifi.slash")
                        .foregroundColor(.customGreen.opacity(0.6))
                }
                .symbolEffect(.pulse, options: .repeat(5))
            case .decodingError:
                Label {
                    Text("Decoding Error")
                } icon: {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.customGreen.opacity(0.6))
                }
                .symbolEffect(.rotate, options: .nonRepeating)
            case .invalidID:
                Label {
                    Text("Invalid ID")
                } icon: {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.customGreen.opacity(0.6))
                }
                .symbolEffect(.wiggle, options: .nonRepeating)
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
