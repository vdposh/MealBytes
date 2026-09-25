//
//  NutrientType+Extensions.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 25.09.2026.
//

import SwiftUI

extension NutrientType {
    var iconName: String {
        switch self {
        case .calories: "flame.fill"
        case .fat: "f.circle.fill"
        case .carbohydrate: "c.circle.fill"
        case .protein: "p.circle.fill"
        default: "circle.fill"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .calories: .customCalories
        case .fat: .customFat
        case .carbohydrate: .customCarbs
        case .protein: .customProtein
        default: .customGray
        }
    }
    
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
