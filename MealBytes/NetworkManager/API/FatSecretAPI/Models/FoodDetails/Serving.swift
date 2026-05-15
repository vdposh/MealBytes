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
        
        func roundValue(_ value: Double, to places: Int) -> Double {
            let multiplier = pow(10.0, Double(places))
            return (value * multiplier).rounded() / multiplier
        }
        
        func decodeString(forKey key: CodingKeys) -> String {
            (try? container.decode(String.self, forKey: key)) ?? ""
        }
        
        func decodeInt(forKey key: CodingKeys) -> Int {
            let stringValue = (
                try? container.decodeIfPresent(String.self, forKey: key)
            ) ?? ""
            let doubleValue = Double(stringValue) ?? 0
            return Int(
                roundValue(
                    doubleValue,
                    to: NutrientPrecision.calories.rawValue
                )
            )
        }
        
        func decodeValue(forKey key: CodingKeys, to places: Int) -> Double {
            let stringValue = (
                try? container.decodeIfPresent(String.self, forKey: key)
            ) ?? ""
            guard let doubleValue = Double(stringValue) else { return 0.0 }
            return roundValue(doubleValue, to: places)
        }
        
        calories = decodeInt(forKey: .calories)
        
        fat = decodeValue(
            forKey: .fat,
            to: NutrientPrecision.nutrients.rawValue
        )
        carbohydrate = decodeValue(
            forKey: .carbohydrate,
            to: NutrientPrecision.nutrients.rawValue
        )
        protein = decodeValue(
            forKey: .protein,
            to: NutrientPrecision.nutrients.rawValue
        )
        
        saturatedFat = decodeValue(
            forKey: .saturatedFat,
            to: NutrientPrecision.nutrients.rawValue
        )
        monounsaturatedFat = decodeValue(
            forKey: .monounsaturatedFat,
            to: NutrientPrecision.nutrients.rawValue
        )
        polyunsaturatedFat = decodeValue(
            forKey: .polyunsaturatedFat,
            to: NutrientPrecision.nutrients.rawValue
        )
        sugar = decodeValue(
            forKey: .sugar,
            to: NutrientPrecision.nutrients.rawValue
        )
        fiber = decodeValue(
            forKey: .fiber,
            to: NutrientPrecision.nutrients.rawValue
        )
        sodium = decodeValue(
            forKey: .sodium,
            to: NutrientPrecision.nutrients.rawValue
        )
        cholesterol = decodeValue(
            forKey: .cholesterol,
            to: NutrientPrecision.nutrients.rawValue
        )
        potassium = decodeValue(
            forKey: .potassium,
            to: NutrientPrecision.nutrients.rawValue
        )
        
        metricServingAmount = decodeValue(
            forKey: .metricServingAmount,
            to: NutrientPrecision.nutrients.rawValue
        )
        measurementDescription = decodeString(forKey: .measurementDescription)
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
    
    private enum NutrientPrecision: Int {
        case calories = 0
        case nutrients = 2
    }
}

enum MeasurementUnit: String, CaseIterable, Identifiable {
    case servings = "Servings"
    case grams = "Grams"
    
    var id: String { self.rawValue }
}

#Preview {
    PreviewContentView.contentView
}
