//
//  NutrientDetailProvider.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

import SwiftUI

struct NutrientDetailProvider {
    struct NutrientDetail {
        let type: NutrientType
        let value: Double
        let isSubValue: Bool
    }
    
    func getNutrientDetails(from serving: Serving) -> [NutrientDetail] {
        [
            NutrientDetail(type: .calories,
                           value: serving.calories, isSubValue: false),
            NutrientDetail(type: .servingSize(
                metricServingUnit: serving.metricServingUnit),
                           value: serving.metricServingAmount,
                           isSubValue: true),
            NutrientDetail(type: .fat, value: serving.fat,
                           isSubValue: false),
            NutrientDetail(type: .saturatedFat,
                           value: serving.saturatedFat,
                           isSubValue: true),
            NutrientDetail(type: .monounsaturatedFat,
                           value: serving.monounsaturatedFat,
                           isSubValue: true),
            NutrientDetail(type: .polyunsaturatedFat,
                           value: serving.polyunsaturatedFat,
                           isSubValue: true),
            NutrientDetail(type: .carbohydrates,
                           value: serving.carbohydrate,
                           isSubValue: false),
            NutrientDetail(type: .sugar, value: serving.sugar,
                           isSubValue: true),
            NutrientDetail(type: .fiber, value: serving.fiber,
                           isSubValue: true),
            NutrientDetail(type: .protein, value: serving.protein,
                           isSubValue: false),
            NutrientDetail(type: .potassium, value: serving.potassium,
                           isSubValue: true),
            NutrientDetail(type: .sodium, value: serving.sodium,
                           isSubValue: false),
            NutrientDetail(type: .cholesterol,
                           value: serving.cholesterol, isSubValue: true)
        ]
    }
}
