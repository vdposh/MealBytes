//
//  Serving.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
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
    let calories: Int
    let sodium: Double
    let cholesterol: Double
    let potassium: Double
    let measurementDescription: String
    let metricServingAmount: Double
    let metricServingUnit: String
    
    var measurementUnit: MeasurementUnit {
        if isMetricMeasurement {
            return .grams
        } else {
            return .servings
        }
    }
    
    var isMetricMeasurement: Bool {
        [
            MeasurementType.grams.description,
            MeasurementType.milliliters.description
        ].contains(measurementDescription)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let formatter = Formatter()
        
        func decodeString(forKey key: CodingKeys) -> String {
            (try? container.decode(String.self, forKey: key)) ?? ""
        }
        
        func decodeInt(forKey key: CodingKeys) -> Int {
            let stringValue = (
                try? container.decodeIfPresent(String.self, forKey: key)
            ) ?? ""
            let doubleValue = Double(stringValue) ?? 0
            return Int(formatter.round(doubleValue, to: 0))
        }
        
        func decodeValue(forKey key: CodingKeys, to places: Int) -> Double {
            let stringValue = (
                try? container.decodeIfPresent(String.self, forKey: key)
            ) ?? ""
            guard let doubleValue = Double(stringValue) else { return 0.0 }
            return formatter.round(doubleValue, to: places)
        }
        
        calories = decodeInt(forKey: .calories)
        
        fat = decodeValue(forKey: .fat, to: 2)
        carbohydrate = decodeValue(forKey: .carbohydrate, to: 2)
        protein = decodeValue(forKey: .protein, to: 2)
        
        saturatedFat = decodeValue(forKey: .saturatedFat, to: 3)
        monounsaturatedFat = decodeValue(forKey: .monounsaturatedFat, to: 3)
        polyunsaturatedFat = decodeValue(forKey: .polyunsaturatedFat, to: 3)
        sugar = decodeValue(forKey: .sugar, to: 3)
        fiber = decodeValue(forKey: .fiber, to: 3)
        sodium = decodeValue(forKey: .sodium, to: 3)
        cholesterol = decodeValue(forKey: .cholesterol, to: 3)
        potassium = decodeValue(forKey: .potassium, to: 3)
        
        measurementDescription = decodeString(forKey: .measurementDescription)
        metricServingAmount = decodeValue(forKey: .metricServingAmount, to: 2)
        metricServingUnit = decodeString(forKey: .metricServingUnit)
    }
    
    private enum CodingKeys: String, CodingKey {
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
    
    private enum MeasurementType: String {
        case grams
        case milliliters
        
        var description: String {
            switch self {
            case .grams: "g"
            case .milliliters: "ml"
            }
        }
    }
}

enum MeasurementUnit: String, CaseIterable, Identifiable {
    case servings = "Servings"
    case grams = "Grams"
    
    var id: String { self.rawValue }
}
