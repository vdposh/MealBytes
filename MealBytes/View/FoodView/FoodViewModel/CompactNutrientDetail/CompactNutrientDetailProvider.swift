//
//  CompactNutrientDetailProvider.swift
//  MealBytes
//
//  Created by Porshe on 09/03/2025.
//

import SwiftUI

struct CompactNutrientDetailProvider {
    struct CompactNutrientDetail {
        let title: String
        let value: Double
        let unit: String
    }
    
    func getCompactNutrientDetails(from serving: Serving) ->
    [CompactNutrientDetail] {
        [
            CompactNutrientDetail(title: NutrientType.calories.title,
                                  value: serving.calories, unit: ""),
            CompactNutrientDetail(title: NutrientType.fat.title,
                                  value: serving.fat, unit: "g"),
            CompactNutrientDetail(title: NutrientType.protein.title,
                                  value: serving.protein, unit: "g"),
            CompactNutrientDetail(
                title: NutrientType.carbohydrates.alternativeTitle,
                value: serving.carbohydrate, unit: "g")
        ]
    }
}
