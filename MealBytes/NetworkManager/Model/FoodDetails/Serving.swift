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
    
    var measurementUnit: MeasurementUnit {
        switch isGramsOrMilliliters {
        case true:
            .grams
        case false:
            .servings
        }
    }
    
    var isGramsOrMilliliters: Bool {
        switch measurementDescription {
        case MeasurementType.grams.rawValue,
            MeasurementType.milliliters.rawValue:
            true
        default:
            false
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case fat,
             saturatedFat = "saturated_fat",
             monounsaturatedFat = "monounsaturated_fat",
             polyunsaturatedFat = "polyunsaturated_fat",
             carbohydrate,
             sugar,
             fiber,
             protein,
             calories,
             sodium,
             cholesterol,
             potassium,
             measurementDescription = "measurement_description",
             metricServingAmount = "metric_serving_amount",
             metricServingUnit = "metric_serving_unit"
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
        saturatedFat = decodeDouble(forKey: .saturatedFat)
        monounsaturatedFat = decodeDouble(forKey: .monounsaturatedFat)
        polyunsaturatedFat = decodeDouble(forKey: .polyunsaturatedFat)
        carbohydrate = decodeDouble(forKey: .carbohydrate)
        sugar = decodeDouble(forKey: .sugar)
        fiber = decodeDouble(forKey: .fiber)
        protein = decodeDouble(forKey: .protein)
        calories = decodeDouble(forKey: .calories)
        sodium = decodeDouble(forKey: .sodium)
        cholesterol = decodeDouble(forKey: .cholesterol)
        potassium = decodeDouble(forKey: .potassium)
        measurementDescription = decodeString(forKey: .measurementDescription)
        metricServingAmount = decodeDouble(forKey: .metricServingAmount)
        metricServingUnit = decodeString(forKey: .metricServingUnit)
    }
}
