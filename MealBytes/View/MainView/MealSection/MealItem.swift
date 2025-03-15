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
    let portionUnit: String // Новое свойство для описания порции
    let calories: Double
    let fats: Double
    let proteins: Double
    let carbohydrates: Double
    let rsk: String
}
