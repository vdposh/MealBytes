//
//  CompactNutrientValueProvider.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 09/03/2025.
//

import SwiftUI

struct CompactNutrientValueProvider {
    func getCompactNutrientDetails(
        from serving:
        Serving
    ) -> [CompactNutrientValue] {
        [
            CompactNutrientValue(
                type: .calories,
                value: serving.calories,
                serving: serving
            ),
            CompactNutrientValue(
                type: .fat,
                value: serving.fat,
                serving: serving
            ),
            CompactNutrientValue(
                type: .carbohydrate,
                value: serving.carbohydrate,
                serving: serving
            ),
            CompactNutrientValue(
                type: .protein,
                value: serving.protein,
                serving: serving
            )
        ]
    }
}
