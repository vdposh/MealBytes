//
//  NutrientValue.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/09/2025.
//

import SwiftUI

struct NutrientValue: Identifiable {
    var id: String {
        String(describing: type)
    }
    let type: NutrientType
    let value: Double
    let isSubValue: Bool
    let unit: UnitNutrients
    
    init(
        type: NutrientType,
        value: Double?,
        isSubValue: Bool,
        unit: UnitNutrients = .empty
    ) {
        self.type = type
        self.value = value ?? 0.0
        self.isSubValue = isSubValue
        self.unit = unit
    }
    
    var formattedValue: String {
        if type == .calories {
            return value.asCalories()
        } else {
            return value.asNutrient(unit: unit.description(for: value))
        }
    }
    
    var formattedValueOrDash: String {
        value == 0 ? "-" : formattedValue
    }
}
