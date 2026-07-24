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
        value.asWhole(unit: unit.unitDescription(for: value))
    }
    
    var displayTitle: String {
        [.fat, .carbohydrate].contains(type) ? type.longTitle : type.title
    }
}
