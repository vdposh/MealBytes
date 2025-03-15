//
//  MealItem.swift
//  MealBytes
//
//  Created by Porshe on 15/03/2025.
//

import SwiftUI

struct MealItem: Identifiable {
    var id: UUID = UUID()
    let foodName: String
    let portionSize: Double
    let calories: Double
    let fats: Double
    let proteins: Double
    let carbohydrates: Double
    let rsk: String
}
