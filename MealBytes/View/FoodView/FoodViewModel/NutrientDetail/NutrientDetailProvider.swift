//
//  NutrientDetailProvider.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

import SwiftUI

struct NutrientDetailProvider {
    func getNutrientDetails(from serving:
                            Serving) -> [NutrientDetail] {
        [
            NutrientDetail(
                type: .calories,
                value: serving.calories,
                unit: NutrientType.calories.unit(for: serving),
                isSubValue: false
            ),
            NutrientDetail(
                type: .servingSize,
                value: serving.metricServingAmount,
                unit: NutrientType.servingSize.unit(for: serving),
                isSubValue: true
            ),
            NutrientDetail(
                type: .fat,
                value: serving.fat,
                unit: NutrientType.fat.unit(for: serving),
                isSubValue: false
            ),
            NutrientDetail(
                type: .saturatedFat,
                value: serving.saturatedFat,
                unit: NutrientType.saturatedFat.unit(for: serving),
                isSubValue: true
            ),
            NutrientDetail(
                type: .monounsaturatedFat,
                value: serving.monounsaturatedFat,
                unit: NutrientType.monounsaturatedFat.unit(for: serving),
                isSubValue: true
            ),
            NutrientDetail(
                type: .polyunsaturatedFat,
                value: serving.polyunsaturatedFat,
                unit: NutrientType.polyunsaturatedFat.unit(for: serving),
                isSubValue: true
            ),
            NutrientDetail(
                type: .carbohydrates,
                value: serving.carbohydrate,
                unit: NutrientType.carbohydrates.unit(for: serving),
                isSubValue: false
            ),
            NutrientDetail(
                type: .sugar,
                value: serving.sugar,
                unit: NutrientType.sugar.unit(for: serving),
                isSubValue: true
            ),
            NutrientDetail(
                type: .fiber,
                value: serving.fiber,
                unit: NutrientType.fiber.unit(for: serving),
                isSubValue: true
            ),
            NutrientDetail(
                type: .protein,
                value: serving.protein,
                unit: NutrientType.protein.unit(for: serving),
                isSubValue: false
            ),
            NutrientDetail(
                type: .potassium,
                value: serving.potassium,
                unit: NutrientType.potassium.unit(for: serving),
                isSubValue: true
            ),
            NutrientDetail(
                type: .sodium,
                value: serving.sodium,
                unit: NutrientType.sodium.unit(for: serving),
                isSubValue: true
            ),
            NutrientDetail(
                type: .cholesterol,
                value: serving.cholesterol,
                unit: NutrientType.cholesterol.unit(for: serving),
                isSubValue: true
            )
        ]
    }
}
