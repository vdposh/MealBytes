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
    
    var errorDescription: String {
        switch self {
        case .network:
            "There was a problem connecting to the network. Please check your internet connection and try again."
        case .decoding:
            "There was a problem decoding the data. Please ensure the data format is correct and try again."
        case .results:
            ""
        }
    }
    
    @ViewBuilder
    func contentUnavailableView(query: String, action: @escaping ()
                                -> Void) -> some View {
        ContentUnavailableView {
            switch self {
            case .network:
                Label {
                    Text("Network Error")
                } icon: {
                    Image(systemName: "wifi.slash")
                        .foregroundColor(.customGreen.opacity(0.6))
                }
                .symbolEffect(.pulse)
            case .decoding:
                Label {
                    Text("Decoding Error")
                } icon: {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.customGreen.opacity(0.6))
                }
                .symbolEffect(.rotate, options: .nonRepeating)
            case .results:
                ContentUnavailableView.search(text: query)
            }
        } description: {
            Text(errorDescription)
        } actions: {
            if case .network = self {
                Button("Refresh", action: action)
            }
        }
    }
}
