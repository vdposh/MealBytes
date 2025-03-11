//
//  NutrientDetail.swift
//  MealBytes
//
//  Created by Porshe on 09/03/2025.
//

import SwiftUI

struct NutrientDetail: Identifiable {
    var id: String {
        String(describing: type)
    }
    let type: NutrientType
    let value: Double
    let unit: String
    let isSubValue: Bool
    
    init(type: NutrientType,
         value: Double,
         unit: String,
         isSubValue: Bool) {
        self.type = type
        self.value = value
        self.unit = unit
        self.isSubValue = isSubValue
    }
}
