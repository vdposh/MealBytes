//
//  NutrientType+Extensions.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23.07.2026.
//

import SwiftUI

extension NutrientType {
    var dailyValue: Double? {
        switch self {
        case .fat: 78
        case .saturatedFat: 20
        case .cholesterol: 300
        case .sodium: 2300
        case .carbohydrate: 275
        case .fiber: 28
        case .addedSugars: 50
        case .protein: 50
        case .vitaminD: 20
        case .calcium: 1300
        case .iron: 18
        case .potassium: 4700
        default: nil
        }
    }
}
