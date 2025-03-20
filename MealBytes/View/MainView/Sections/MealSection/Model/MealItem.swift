//
//  MealItem.swift
//  MealBytes
//
//  Created by Porshe on 15/03/2025.
//

import SwiftUI

struct MealItem: Identifiable {
    let id: UUID
    let foodId: Int
    let foodName: String
    let portionUnit: String
    let nutrients: [NutrientType: Double]
    let measurementDescription: String
    let amount: Double
    let date: Date
    
    init(id: UUID = UUID(),
         foodId: Int,
         foodName: String,
         portionUnit: String,
         nutrients: [NutrientType: Double],
         measurementDescription: String,
         amount: Double,
         date: Date = Date()) {
        self.id = id
        self.foodId = foodId
        self.foodName = foodName
        self.portionUnit = portionUnit
        self.nutrients = nutrients
        self.measurementDescription = measurementDescription
        self.amount = amount
        self.date = date
    }
}
