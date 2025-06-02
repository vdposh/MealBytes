//
//  NutrientDetailProvider.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/03/2025.
//

import SwiftUI

struct NutrientDetailProvider {
    func getNutrientDetails(from serving:
                            Serving) -> [NutrientDetail] {
        [
            NutrientDetail(
                type: .calories,
                value: serving.calories,
                serving: serving,
                isSubValue: false
            ),
            NutrientDetail(
                type: .servingSize,
                value: serving.metricServingAmount,
                serving: serving,
                isSubValue: true
            ),
            NutrientDetail(
                type: .fat,
                value: serving.fat,
                serving: serving,
                isSubValue: false
            ),
            NutrientDetail(
                type: .saturatedFat,
                value: serving.saturatedFat,
                serving: serving,
                isSubValue: true
            ),
            NutrientDetail(
                type: .monounsaturatedFat,
                value: serving.monounsaturatedFat,
                serving: serving,
                isSubValue: true
            ),
            NutrientDetail(
                type: .polyunsaturatedFat,
                value: serving.polyunsaturatedFat,
                serving: serving,
                isSubValue: true
            ),
            NutrientDetail(
                type: .carbohydrate,
                value: serving.carbohydrate,
                serving: serving,
                isSubValue: false
            ),
            NutrientDetail(
                type: .sugar,
                value: serving.sugar,
                serving: serving,
                isSubValue: true
            ),
            NutrientDetail(
                type: .fiber,
                value: serving.fiber,
                serving: serving,
                isSubValue: true
            ),
            NutrientDetail(
                type: .protein,
                value: serving.protein,
                serving: serving,
                isSubValue: false
            ),
            NutrientDetail(
                type: .potassium,
                value: serving.potassium,
                serving: serving,
                isSubValue: true
            ),
            NutrientDetail(
                type: .sodium,
                value: serving.sodium,
                serving: serving,
                isSubValue: true
            ),
            NutrientDetail(
                type: .cholesterol,
                value: serving.cholesterol,
                serving: serving,
                isSubValue: true
            )
        ]
    }
}
