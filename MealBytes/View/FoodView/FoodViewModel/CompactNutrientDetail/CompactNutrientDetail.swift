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
    let serving: Serving
    
    var unit: String {
        switch type {
        case .calories:
            type.alternativeUnit(for: serving)
        default:
            type.unit(for: serving)
        }
    }
    
    init(type: NutrientType,
         value: Double,
         serving: Serving) {
        self.type = type
        self.title = type.alternativeTitle
        self.value = value
        self.serving = serving
    }
}
