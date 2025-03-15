//
//  MealItem.swift
//  MealBytes
//
//  Created by Porshe on 15/03/2025.
//

import SwiftUI

struct MealItem: Identifiable {
    let id = UUID()
    let foodName: String
    let portionSize: Double
    let portionUnit: String
    let nutrients: [NutrientType: Double]
    let rsk: String
}
