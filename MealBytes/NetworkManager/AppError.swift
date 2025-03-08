//
//  AppError.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

class AppError: Identifiable, ObservableObject {
    let id = UUID()
    let title: String
    let message: String

    init(error: Error) {
        if let appError = error as? AppErrorType {
            self.title = "Error"
            self.message = appError.errorDescription
        } else {
            self.title = "Unknown Error"
            self.message = error.localizedDescription
        }
    }
}

enum AppErrorType: Error, LocalizedError {
    case invalidID
    case networkError
    case decodingError

    var errorDescription: String {
        switch self {
        case .invalidID:
            return "Invalid Identifier: The ID provided is not valid. Please check and try again."
        case .networkError:
            return "Network Error: There was a problem connecting to the network. Please check your internet connection and try again."
        case .decodingError:
            return "Decoding Error: There was a problem decoding the data. Please ensure the data format is correct and try again."
        }
    }
}
