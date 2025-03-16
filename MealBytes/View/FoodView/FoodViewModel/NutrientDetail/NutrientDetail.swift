//
//  NutrientDetail.swift
//  MealBytes
//
//  Created by Porshe on 09/03/2025.
//

import SwiftUI

// MARK: - Represents a detailed model of a nutrient, including its type, value, serving size, and whether it is a sub-value
struct NutrientDetail: Identifiable {
    var id: String {
        String(describing: type)
    }
    let type: NutrientType
    let value: Double
    let serving: Serving
    let isSubValue: Bool
    
    init(type: NutrientType,
         value: Double,
         serving: Serving,
         isSubValue: Bool) {
        self.type = type
        self.value = value
        self.serving = serving
        self.isSubValue = isSubValue
    }
}

extension NutrientDetail {
    var formattedValue: String {
        Formatter().formattedValue(
            value,
            unit: Formatter.Unit(rawValue: type.unit(for: serving)) ?? .empty,
            alwaysRoundUp: type == .calories)
    }
}

