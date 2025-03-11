//
//  CompactNutrientDetailProvider.swift
//  MealBytes
//
//  Created by Porshe on 09/03/2025.
//

import SwiftUI

struct CompactNutrientDetailProvider {
    func getCompactNutrientDetails(from serving:
                                   Serving) -> [CompactNutrientDetail] {
        [
            CompactNutrientDetail(
                id: "calories",
                type: .calories,
                value: serving.calories,
                unit: NutrientType.calories.alternativeUnit
            ),
            CompactNutrientDetail(
                id: "fat",
                type: .fat,
                value: serving.fat,
                unit: NutrientType.fat.unit
            ),
            CompactNutrientDetail(
                id: "protein",
                type: .protein,
                value: serving.protein,
                unit: NutrientType.protein.unit
            ),
            CompactNutrientDetail(
                id: "carbohydrates",
                type: .carbohydrates,
                value: serving.carbohydrate,
                unit: NutrientType.carbohydrates.unit
            )
        ]
    }
}
