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
    let unit: Formatter.Unit
    
    init(
        type: NutrientType,
        value: Double?,
        isSubValue: Bool,
        unit: Formatter.Unit = .empty
    ) {
        self.type = type
        self.value = value ?? 0.0
        self.isSubValue = isSubValue
        self.unit = unit
    }
    
    var formattedValue: String {
        Formatter().formattedValue(
            value,
            unit: unit,
            alwaysRoundUp: type == .calories
        )
    }
    
    var formattedValueOrDash: String {
        value == 0 ? "-" : formattedValue
    }
}
