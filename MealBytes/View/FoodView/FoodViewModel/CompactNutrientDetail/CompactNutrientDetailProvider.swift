//
//  CompactNutrientDetailProvider.swift
//  MealBytes
//
//  Created by Porshe on 09/03/2025.
//

import SwiftUI

// MARK: - Responsible for generating an array of CompactNutrientDetail objects by extracting nutrient values like calories, fat, carbohydrates, and protein from a given serving
struct CompactNutrientDetailProvider {
    func getCompactNutrientDetails(from serving:
                                   Serving) -> [CompactNutrientDetail] {
        [
            CompactNutrientDetail(
                type: .calories,
                value: serving.calories,
                serving: serving
            ),
            CompactNutrientDetail(
                type: .fat,
                value: serving.fat,
                serving: serving
            ),
            CompactNutrientDetail(
                type: .carbohydrates,
                value: serving.carbohydrate,
                serving: serving
            ),
            CompactNutrientDetail(
                type: .protein,
                value: serving.protein,
                serving: serving
            )
        ]
    }
}
