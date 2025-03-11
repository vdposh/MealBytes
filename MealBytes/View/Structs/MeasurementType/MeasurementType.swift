//
//  MeasurementType.swift
//  MealBytes
//
//  Created by Porshe on 11/03/2025.
//

import SwiftUI

enum MeasurementType: String {
    case grams
    case milliliters
    case servings

    var description: String {
        switch self {
        case .grams: "g"
        case .milliliters: "ml"
        case .servings: "serving"
        }
    }
}
