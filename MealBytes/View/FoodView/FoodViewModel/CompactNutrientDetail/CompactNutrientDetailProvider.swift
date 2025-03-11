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
                type: .calories,
                value: serving.calories,
                unit: NutrientType.calories.alternativeUnit(for: serving)
            ),
            CompactNutrientDetail(
                type: .fat,
                value: serving.fat,
                unit: NutrientType.fat.unit(for: serving)
            ),
            CompactNutrientDetail(
                type: .protein,
                value: serving.protein,
                unit: NutrientType.protein.unit(for: serving)
            ),
            CompactNutrientDetail(
                type: .carbohydrates,
                value: serving.carbohydrate,
                unit: NutrientType.carbohydrates.unit(for: serving)
            )
        ]
    }
}
