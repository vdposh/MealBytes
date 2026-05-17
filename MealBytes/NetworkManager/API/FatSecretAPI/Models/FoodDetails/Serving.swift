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
    let calories: Double
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
        
        func decodeString(forKey key: CodingKeys) -> String {
            (try? container.decode(String.self, forKey: key)) ?? ""
        }
        
        func decodeDouble(forKey key: CodingKeys) -> Double {
            let stringValue = (
                try? container.decodeIfPresent(String.self, forKey: key)
            ) ?? ""
            return Double(stringValue) ?? 0
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
        
        metricServingAmount = decodeDouble(forKey: .metricServingAmount)
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
}

enum MeasurementUnit: String, CaseIterable, Identifiable {
    case servings = "Servings"
    case grams = "Grams"
    
    var id: String { self.rawValue }
}

#Preview {
    PreviewContentView.contentView
}
