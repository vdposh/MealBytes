//
//  MealItem.swift
//  MealBytes
//
//  Created by Porshe on 15/03/2025.
//

import SwiftUI

struct MealItem: Identifiable {
    let id = UUID()
    let foodId: Int
    let foodName: String
    let portionUnit: String
    let nutrients: [NutrientType: Double]
    let servingDescription: String
    let amount: Double
}
