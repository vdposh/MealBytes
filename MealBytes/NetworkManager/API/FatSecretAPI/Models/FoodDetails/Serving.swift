//
//  Serving.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct Serving: Decodable, Hashable {
    let calories: Double
    let fat: Double
    let saturatedFat: Double
    let transFat: Double
    let polyunsaturatedFat: Double
    let monounsaturatedFat: Double
    let cholesterol: Double
    let sodium: Double
    let carbohydrate: Double
    let fiber: Double
    let sugar: Double
    let addedSugars: Double
    let protein: Double
    let vitaminD: Double
    let calcium: Double
    let iron: Double
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
        
        calories = decodeDouble(forKey: .calories)
        fat = decodeDouble(forKey: .fat)
        saturatedFat = decodeDouble(forKey: .saturatedFat)
        transFat = decodeDouble(forKey: .transFat)
        polyunsaturatedFat = decodeDouble(forKey: .polyunsaturatedFat)
        monounsaturatedFat = decodeDouble(forKey: .monounsaturatedFat)
        cholesterol = decodeDouble(forKey: .cholesterol)
        sodium = decodeDouble(forKey: .sodium)
        carbohydrate = decodeDouble(forKey: .carbohydrate)
        fiber = decodeDouble(forKey: .fiber)
        sugar = decodeDouble(forKey: .sugar)
        addedSugars = decodeDouble(forKey: .addedSugars)
        protein = decodeDouble(forKey: .protein)
        vitaminD = decodeDouble(forKey: .vitaminD)
        calcium = decodeDouble(forKey: .calcium)
        iron = decodeDouble(forKey: .iron)
        potassium = decodeDouble(forKey: .potassium)
        
        metricServingAmount = decodeDouble(forKey: .metricServingAmount)
        measurementDescription = decodeString(forKey: .measurementDescription)
        metricServingUnit = decodeString(forKey: .metricServingUnit)
    }
    
    private enum CodingKeys: String, CodingKey {
        case calories
        case fat
        case saturatedFat = "saturated_fat"
        case transFat = "trans_fat"
        case polyunsaturatedFat = "polyunsaturated_fat"
        case monounsaturatedFat = "monounsaturated_fat"
        case cholesterol
        case sodium
        case carbohydrate
        case fiber
        case sugar
        case addedSugars = "added_sugars"
        case protein
        case vitaminD = "vitamin_d"
        case calcium
        case iron
        case potassium
        case measurementDescription = "measurement_description"
        case metricServingAmount = "metric_serving_amount"
        case metricServingUnit = "metric_serving_unit"
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
