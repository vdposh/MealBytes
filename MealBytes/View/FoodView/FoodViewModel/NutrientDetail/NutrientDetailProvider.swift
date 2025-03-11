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
                id: "calories",
                type: .calories,
                value: serving.calories,
                unit: NutrientType.calories.unit,
                isSubValue: false
            ),
            NutrientDetail(
                id: "servingSize",
                type: .servingSize(
                    metricServingUnit: serving.metricServingUnit
                ),
                value: serving.metricServingAmount,
                unit: serving.metricServingUnit,
                isSubValue: true
            ),
            NutrientDetail(
                id: "fat",
                type: .fat,
                value: serving.fat,
                unit: NutrientType.fat.unit,
                isSubValue: false
            ),
            NutrientDetail(
                id: "saturatedFat",
                type: .saturatedFat,
                value: serving.saturatedFat,
                unit: NutrientType.saturatedFat.unit,
                isSubValue: true
            ),
            NutrientDetail(
                id: "monounsaturatedFat",
                type: .monounsaturatedFat,
                value: serving.monounsaturatedFat,
                unit: NutrientType.monounsaturatedFat.unit,
                isSubValue: true
            ),
            NutrientDetail(
                id: "polyunsaturatedFat",
                type: .polyunsaturatedFat,
                value: serving.polyunsaturatedFat,
                unit: NutrientType.polyunsaturatedFat.unit,
                isSubValue: true
            ),
            NutrientDetail(
                id: "carbohydrates",
                type: .carbohydrates,
                value: serving.carbohydrate,
                unit: NutrientType.carbohydrates.unit,
                isSubValue: false
            ),
            NutrientDetail(
                id: "sugar",
                type: .sugar,
                value: serving.sugar,
                unit: NutrientType.sugar.unit,
                isSubValue: true
            ),
            NutrientDetail(
                id: "fiber",
                type: .fiber,
                value: serving.fiber,
                unit: NutrientType.fiber.unit,
                isSubValue: true
            ),
            NutrientDetail(
                id: "protein",
                type: .protein,
                value: serving.protein,
                unit: NutrientType.protein.unit,
                isSubValue: false
            ),
            NutrientDetail(
                id: "potassium",
                type: .potassium,
                value: serving.potassium,
                unit: NutrientType.potassium.unit,
                isSubValue: true
            ),
            NutrientDetail(
                id: "sodium",
                type: .sodium,
                value: serving.sodium,
                unit: NutrientType.sodium.unit,
                isSubValue: true
            ),
            NutrientDetail(
                id: "cholesterol",
                type: .cholesterol,
                value: serving.cholesterol,
                unit: NutrientType.cholesterol.unit,
                isSubValue: true
            )
        ]
    }
}
