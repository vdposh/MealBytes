//
//  MealItem.swift
//  MealBytes
//
//  Created by Porshe on 15/03/2025.
//

import SwiftUI
import FirebaseCore

struct MealItem: Identifiable {
    let id: UUID
    let foodId: Int
    let foodName: String
    let portionUnit: String
    let nutrients: [NutrientType: Double]
    let measurementDescription: String
    let amount: Double
    let date: Date
    let mealType: MealType // Новое свойство
    
    init(id: UUID = UUID(),
         foodId: Int,
         foodName: String,
         portionUnit: String,
         nutrients: [NutrientType: Double],
         measurementDescription: String,
         amount: Double,
         date: Date = Date(),
         mealType: MealType) { // Добавлен параметр mealType
        self.id = id
        self.foodId = foodId
        self.foodName = foodName
        self.portionUnit = portionUnit
        self.nutrients = nutrients
        self.measurementDescription = measurementDescription
        self.amount = amount
        self.date = date
        self.mealType = mealType
    }
    
    func toDictionary() -> [String: Any] {
        [
            "id": id.uuidString,
            "foodId": foodId,
            "foodName": foodName,
            "portionUnit": portionUnit,
            "nutrients": nutrients.mapKeys { $0.rawValue },
            "measurementDescription": measurementDescription,
            "amount": amount,
            "date": Timestamp(date: date),
            "mealType": mealType.rawValue // Сохраняем MealType как строку
        ]
    }
}
