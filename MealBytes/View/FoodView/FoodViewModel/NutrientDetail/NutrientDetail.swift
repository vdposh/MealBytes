//
//  NutrientDetail.swift
//  MealBytes
//
//  Created by Porshe on 09/03/2025.
//

import SwiftUI

struct NutrientDetail: Identifiable {
    let id: String
    let type: NutrientType
    let value: Double
    let unit: String
    let isSubValue: Bool
    
    init(id: String,
         type: NutrientType,
         value: Double,
         unit: String,
         isSubValue: Bool) {
        self.id = id
        self.type = type
        self.value = value
        self.unit = unit
        self.isSubValue = isSubValue
    }
}
