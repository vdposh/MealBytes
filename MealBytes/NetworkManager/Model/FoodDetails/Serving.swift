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
        case fat
        case saturated_fat
        case monounsaturated_fat
        case polyunsaturated_fat
        case carbohydrate
        case sugar
        case fiber
        case protein
        case calories
        case sodium
        case cholesterol
        case potassium
        case measurement_description // описание порции
        case metric_serving_amount // количество г/мл в порции
        case metric_serving_unit // г или мг ТОЛЬКО у порций
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fat = Self.decodeDouble(container, forKey: .fat)
        saturatedFat = Self.decodeDouble(container, forKey:
                .saturated_fat)
        monounsaturatedFat = Self.decodeDouble(container, forKey:
                .monounsaturated_fat)
        polyunsaturatedFat = Self.decodeDouble(container, forKey:
                .polyunsaturated_fat)
        carbohydrate = Self.decodeDouble(container, forKey:
                .carbohydrate)
        sugar = Self.decodeDouble(container, forKey:
                .sugar)
        fiber = Self.decodeDouble(container, forKey:
                .fiber)
        protein = Self.decodeDouble(container, forKey:
                .protein)
        calories = Self.decodeDouble(container, forKey:
                .calories)
        sodium = Self.decodeDouble(container, forKey:
                .sodium)
        cholesterol = Self.decodeDouble(container, forKey:
                .cholesterol)
        potassium = Self.decodeDouble(container, forKey:
                .potassium)
        measurementDescription = Self.decodeString(container, forKey:
                .measurement_description)
        metricServingAmount = Self.decodeDouble(container, forKey:
                .metric_serving_amount)
        metricServingUnit = Self.decodeString(container, forKey:
                .metric_serving_unit)
    }
    
    private static func decodeDouble(
        _ container: KeyedDecodingContainer<CodingKeys>,
        forKey key: CodingKeys) -> Double {
            (try? Double(container.decodeIfPresent(String.self,
                                                   forKey: key) ?? "")) ?? 0
        }
    
    private static func decodeString(
        _ container: KeyedDecodingContainer<CodingKeys>,
        forKey key: CodingKeys
    ) -> String {
        (try? container.decode(String.self, forKey: key)) ?? ""
    }
}
