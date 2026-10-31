//
//  FoodMetadata.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/10/2025.
//

import SwiftUI

struct FoodMetadata: Codable {
    let foodId: Int
    let foodName: String
    let mealType: MealType
    let amount: String
    let servingDescription: String
    let calories: Double
    let fat: Double
    let carbs: Double
    let protein: Double
    let formattedText: String
    let measurementDescription: String
    let metricServingAmount: Double
    let metricServingUnit: String
    var nutrients: [NutrientType: Double]
    
    init(
        foodId: Int,
        foodName: String,
        mealType: MealType,
        amount: String,
        servingDescription: String,
        calories: Double,
        fat: Double,
        carbs: Double,
        protein: Double,
        formattedText: String,
        measurementDescription: String,
        metricServingAmount: Double,
        metricServingUnit: String,
        nutrients: [NutrientType: Double] = [:]
    ) {
        self.foodId = foodId
        self.foodName = foodName
        self.mealType = mealType
        self.amount = amount
        self.servingDescription = servingDescription
        self.calories = calories
        self.fat = fat
        self.carbs = carbs
        self.protein = protein
        self.formattedText = formattedText
        self.measurementDescription = measurementDescription
        self.metricServingAmount = metricServingAmount
        self.metricServingUnit = metricServingUnit
        self.nutrients = nutrients
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(foodId, forKey: .foodId)
        try container.encode(foodName, forKey: .foodName)
        try container.encode(mealType, forKey: .mealType)
        try container.encode(amount, forKey: .amount)
        try container.encode(servingDescription, forKey: .servingDescription)
        try container.encode(calories, forKey: .calories)
        try container.encode(fat, forKey: .fat)
        try container.encode(carbs, forKey: .carbs)
        try container.encode(protein, forKey: .protein)
        try container.encode(formattedText, forKey: .formattedText)
        try container.encode(
            measurementDescription,
            forKey: .measurementDescription
        )
        try container.encode(
            metricServingAmount,
            forKey: .metricServingAmount
        )
        try container.encode(
            metricServingUnit,
            forKey: .metricServingUnit
        )
        let stringNutrients = nutrients.mapKeys { $0.rawValue }
        try container.encode(stringNutrients, forKey: .nutrients)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        foodId = try container.decode(Int.self, forKey: .foodId)
        foodName = try container.decode(String.self, forKey: .foodName)
        mealType = try container.decode(MealType.self, forKey: .mealType)
        amount = try container.decode(String.self, forKey: .amount)
        servingDescription = try container.decode(
            String.self,
            forKey: .servingDescription
        )
        calories = try container.decode(Double.self, forKey: .calories)
        fat = try container.decode(Double.self, forKey: .fat)
        carbs = try container.decode(Double.self, forKey: .carbs)
        protein = try container.decode(Double.self, forKey: .protein)
        formattedText = try container.decode(
            String.self,
            forKey: .formattedText
        )
        measurementDescription = try container.decode(
            String.self,
            forKey: .measurementDescription
        )
        metricServingAmount = try container.decode(
            Double.self,
            forKey: .metricServingAmount
        )
        metricServingUnit = try container.decode(
            String.self,
            forKey: .metricServingUnit
        )
        
        let stringNutrients = (
            try? container.decode([String: Double].self, forKey: .nutrients)
        ) ?? [:]
        nutrients = stringNutrients.reduce(
            into: [NutrientType: Double]()
        ) { result, pair in
            if let key = NutrientType(rawValue: pair.key) {
                result[key] = pair.value
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case foodId,
             foodName,
             mealType,
             amount,
             servingDescription,
             calories,
             fat,
             carbs,
             protein,
             formattedText,
             measurementDescription,
             metricServingAmount,
             metricServingUnit,
             nutrients
    }
}

#Preview {
    PreviewContentView.contentView
}
