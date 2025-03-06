//
//  Serving.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct Serving: Decodable, Hashable {
    let fat: Double?
    let saturated_fat: Double?
    let monounsaturated_fat: Double?
    let polyunsaturated_fat: Double?
    let carbohydrate: Double?
    let sugar: Double?
    let fiber: Double?
    let protein: Double?
    let calories: Double?
    let sodium: Double?
    let cholesterol: Double?
    let potassium: Double?
    let measurement_description: String?
    let metric_serving_amount: Double?
    let metric_serving_unit: String?

    enum CodingKeys: String, CodingKey {
        case fat = "fat"
        case saturated_fat = "saturated_fat"
        case monounsaturated_fat = "monounsaturated_fat"
        case polyunsaturated_fat = "polyunsaturated_fat"
        case carbohydrate = "carbohydrate"
        case sugar = "sugar"
        case fiber = "fiber"
        case protein = "protein"
        case calories = "calories"
        case sodium = "sodium"
        case cholesterol = "cholesterol"
        case potassium = "potassium"
        case measurement_description = "measurement_description" //описание порции
        case metric_serving_amount = "metric_serving_amount" //количество г/мл в порции
        case metric_serving_unit = "metric_serving_unit" //г или мг ТОЛЬКО у порций
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        fat = try? Double(container
            .decodeIfPresent(String.self, forKey: .fat) ?? "")
        saturated_fat = try? Double(container
            .decodeIfPresent(String.self, forKey: .saturated_fat) ?? "")
        monounsaturated_fat = try? Double(container
            .decodeIfPresent(String.self, forKey: .monounsaturated_fat) ?? "")
        polyunsaturated_fat = try? Double(container
            .decodeIfPresent(String.self, forKey: .polyunsaturated_fat) ?? "")
        carbohydrate = try? Double(container
            .decodeIfPresent(String.self, forKey: .carbohydrate) ?? "")
        sugar = try? Double(container
            .decodeIfPresent(String.self, forKey: .sugar) ?? "")
        fiber = try? Double(container
            .decodeIfPresent(String.self, forKey: .fiber) ?? "")
        protein = try? Double(container
            .decodeIfPresent(String.self, forKey: .protein) ?? "")
        calories = try? Double(container
            .decodeIfPresent(String.self, forKey: .calories) ?? "")
        sodium = try? Double(container
            .decodeIfPresent(String.self, forKey: .sodium) ?? "")
        cholesterol = try? Double(container
            .decodeIfPresent(String.self, forKey: .cholesterol) ?? "")
        potassium = try? Double(container
            .decodeIfPresent(String.self, forKey: .potassium) ?? "")
        measurement_description = try? container
            .decode(String.self, forKey: .measurement_description)
        metric_serving_amount = try? Double(container
            .decodeIfPresent(String.self, forKey: .metric_serving_amount) ?? "")
        metric_serving_unit = try? container
            .decode(String.self, forKey: .metric_serving_unit)
    }
}
