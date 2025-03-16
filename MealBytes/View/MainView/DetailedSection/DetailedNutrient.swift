//
//  DetailedNutrient.swift
//  MealBytes
//
//  Created by Porshe on 15/03/2025.
//

import SwiftUI

//MARK: - Represents the model for a nutrient, containing its type, value, and other related properties
struct DetailedNutrient: Identifiable {
    var id: String {
        String(describing: type)
    }
    let type: NutrientType
    let value: Double
    let isSubValue: Bool
    
    init(type: NutrientType,
         value: Double,
         isSubValue: Bool) {
        self.type = type
        self.value = value
        self.isSubValue = isSubValue
    }
}

extension DetailedNutrient {
    var formattedValue: String {
        Formatter().formattedValue(
            value,
            unit: Formatter.Unit(rawValue: type.alternativeUnit) ?? .empty,
            alwaysRoundUp: type == .calories
        )
    }
}
