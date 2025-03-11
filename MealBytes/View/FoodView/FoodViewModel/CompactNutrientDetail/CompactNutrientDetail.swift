//
//  CompactNutrientDetail.swift
//  MealBytes
//
//  Created by Porshe on 10/03/2025.
//

import SwiftUI

struct CompactNutrientDetail: Identifiable {
    var id: NutrientType { type }
    let type: NutrientType
    let title: String
    let value: Double
    let unit: String
    
    init(type: NutrientType,
         value: Double,
         unit: String) {
        self.type = type
        self.title = type.alternativeTitle
        self.value = value
        self.unit = unit
    }
}
