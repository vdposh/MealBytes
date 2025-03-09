//
//  Serving.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct Serving: Decodable, Hashable {
    let fat: Double
    let saturatedFat: Double
    let monounsaturatedFat: Double
    let polyunsaturatedFat: Double
    let carbohydrate: Double
    let sugar: Double
    let fiber: Double
    let protein: Double
    let calories: Double
    let sodium: Double
    let cholesterol: Double
    let potassium: Double
    let measurementDescription: String
    let metricServingAmount: Double
    let metricServingUnit: String
    
    enum CodingKeys: String, CodingKey {
        case fat, saturated_fat, monounsaturated_fat, polyunsaturated_fat,
             carbohydrate, sugar, fiber, protein, calories, sodium,
             cholesterol, potassium, measurement_description,
             metric_serving_amount, metric_serving_unit
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func decodeDouble(forKey key: CodingKeys) -> Double {
            (try? Double(container.decodeIfPresent(String.self,
                                                   forKey: key) ?? "")) ?? 0
        }
        
        func decodeString(forKey key: CodingKeys) -> String {
            (try? container.decode(String.self, forKey: key)) ?? ""
        }
        
        fat = decodeDouble(forKey: .fat)
        saturatedFat = decodeDouble(forKey: .saturated_fat)
        monounsaturatedFat = decodeDouble(forKey: .monounsaturated_fat)
        polyunsaturatedFat = decodeDouble(forKey: .polyunsaturated_fat)
        carbohydrate = decodeDouble(forKey: .carbohydrate)
        sugar = decodeDouble(forKey: .sugar)
        fiber = decodeDouble(forKey: .fiber)
        protein = decodeDouble(forKey: .protein)
        calories = decodeDouble(forKey: .calories)
        sodium = decodeDouble(forKey: .sodium)
        cholesterol = decodeDouble(forKey: .cholesterol)
        potassium = decodeDouble(forKey: .potassium)
        measurementDescription = decodeString(forKey: .measurement_description)
        metricServingAmount = decodeDouble(forKey: .metric_serving_amount)
        metricServingUnit = decodeString(forKey: .metric_serving_unit)
    }
}
