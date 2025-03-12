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
    let value: Double
    let serving: Serving
    
    init(type: NutrientType,
         value: Double,
         serving: Serving) {
        self.type = type
        self.value = value
        self.serving = serving
    }
}
