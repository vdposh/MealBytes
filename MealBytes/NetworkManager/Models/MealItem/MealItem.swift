//
//  MealItem.swift
//  MealBytes
//
//  Created by Porshe on 15/03/2025.
//

import SwiftUI
import FirebaseCore

struct MealItem: Codable, Identifiable {
    let id: UUID
    let foodId: Int
    let foodName: String
    let portionUnit: String
    var nutrients: [NutrientType: Double]
    let measurementDescription: String
    let amount: Double
    let date: Date
    let mealType: MealType
    let createdAt: Date
    
    init(id: UUID = UUID(),
         foodId: Int,
         foodName: String,
         portionUnit: String,
         nutrients: [NutrientType: Double],
         measurementDescription: String,
         amount: Double,
         date: Date = Date(),
         mealType: MealType,
         createdAt: Date = Date()) {
        self.id = id
        self.foodId = foodId
        self.foodName = foodName
        self.portionUnit = portionUnit
        self.nutrients = nutrients
        self.measurementDescription = measurementDescription
        self.amount = amount
        self.date = date
        self.mealType = mealType
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id,
             foodId,
             foodName,
             portionUnit,
             nutrients,
             measurementDescription,
             amount,
             date,
             mealType,
             createdAt
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(foodId, forKey: .foodId)
        try container.encode(foodName, forKey: .foodName)
        try container.encode(portionUnit, forKey: .portionUnit)
        try container.encode(measurementDescription,
                             forKey: .measurementDescription)
        try container.encode(amount, forKey: .amount)
        try container.encode(date, forKey: .date)
        try container.encode(mealType, forKey: .mealType)
        try container.encode(createdAt, forKey: .createdAt)
        let stringNutrients = nutrients.mapKeys { $0.rawValue }
        try container.encode(stringNutrients, forKey: .nutrients)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        foodId = try container.decode(Int.self, forKey: .foodId)
        foodName = try container.decode(String.self, forKey: .foodName)
        portionUnit = try container.decode(String.self, forKey: .portionUnit)
        measurementDescription = try container.decode(
            String.self, forKey: .measurementDescription)
        amount = try container.decode(Double.self, forKey: .amount)
        date = try container.decode(Date.self, forKey: .date)
        mealType = try container.decode(MealType.self, forKey: .mealType)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        
        let stringNutrients = try container.decode([String: Double].self,
                                                   forKey: .nutrients)
        nutrients = stringNutrients.reduce(into: [NutrientType: Double]()) {
            result, pair in
            if let key = NutrientType(rawValue: pair.key) {
                result[key] = pair.value
            }
        }
    }
}
