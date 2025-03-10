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
        case .invalidID: "Invalid Identifier: The ID provided is not valid. Please check and try again."
        case .networkError: "Network Error: There was a problem connecting to the network. Please check your internet connection and try again."
        case .decodingError: "Decoding Error: There was a problem decoding the data. Please ensure the data format is correct and try again."
        }
    }
}
