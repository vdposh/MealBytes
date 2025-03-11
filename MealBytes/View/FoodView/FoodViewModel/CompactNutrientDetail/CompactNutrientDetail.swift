//
//  CompactNutrientDetail.swift
//  MealBytes
//
//  Created by Porshe on 10/03/2025.
//

import SwiftUI

struct CompactNutrientDetail: Identifiable {
    let id: String
    let type: NutrientType
    let title: String
    let value: Double
    let unit: String
    
    init(id: String,
         type: NutrientType,
         value: Double,
         unit: String) {
        self.id = id
        self.type = type
        self.title = type.alternativeTitle
        self.value = value
        self.unit = unit
    }
}
