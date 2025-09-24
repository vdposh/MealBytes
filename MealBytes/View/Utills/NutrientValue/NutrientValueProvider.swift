//
//  NutrientValueProvider.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/09/2025.
//

import SwiftUI

struct NutrientValueProvider {
    func fromServing(_ serving: Serving) -> [NutrientValue] {
        [
            NutrientValue(
                type: .calories,
                value: serving.calories,
                isSubValue: false
            ),
            NutrientValue(
                type: .servingSize,
                value: serving.metricServingAmount,
                isSubValue: true,
                unit: Formatter
                    .Unit(rawValue: serving.metricServingUnit) ?? .empty
            ),
            NutrientValue(
                type: .fat,
                value: serving.fat,
                isSubValue: false
            ),
            NutrientValue(
                type: .saturatedFat,
                value: serving.saturatedFat,
                isSubValue: true
            ),
            NutrientValue(
                type: .monounsaturatedFat,
                value: serving.monounsaturatedFat,
                isSubValue: true
            ),
            NutrientValue(
                type: .polyunsaturatedFat,
                value: serving.polyunsaturatedFat,
                isSubValue: true
            ),
            NutrientValue(
                type: .carbohydrate,
                value: serving.carbohydrate,
                isSubValue: false
            ),
            NutrientValue(
                type: .sugar,
                value: serving.sugar,
                isSubValue: true
            ),
            NutrientValue(
                type: .fiber,
                value: serving.fiber,
                isSubValue: true
            ),
            NutrientValue(
                type: .protein,
                value: serving.protein,
                isSubValue: false
            ),
            NutrientValue(
                type: .potassium,
                value: serving.potassium,
                isSubValue: true
            ),
            NutrientValue(
                type: .sodium,
                value: serving.sodium,
                isSubValue: true
            ),
            NutrientValue(
                type: .cholesterol,
                value: serving.cholesterol,
                isSubValue: true
            )
        ]
    }
    
    func fromSummary(_ summary: [NutrientType: Double]) -> [NutrientValue] {
        [
            NutrientValue(
                type: .calories,
                value: summary[.calories],
                isSubValue: false
            ),
            NutrientValue(
                type: .fat,
                value: summary[.fat],
                isSubValue: false
            ),
            NutrientValue(
                type: .saturatedFat,
                value: summary[.saturatedFat],
                isSubValue: true
            ),
            NutrientValue(
                type: .monounsaturatedFat,
                value: summary[.monounsaturatedFat],
                isSubValue: true
            ),
            NutrientValue(
                type: .polyunsaturatedFat,
                value: summary[.polyunsaturatedFat],
                isSubValue: true
            ),
            NutrientValue(
                type: .carbohydrate,
                value: summary[.carbohydrate],
                isSubValue: false
            ),
            NutrientValue(
                type: .sugar,
                value: summary[.sugar],
                isSubValue: true
            ),
            NutrientValue(
                type: .fiber,
                value: summary[.fiber],
                isSubValue: true
            ),
            NutrientValue(
                type: .protein,
                value: summary[.protein],
                isSubValue: false
            ),
            NutrientValue(
                type: .potassium,
                value: summary[.potassium],
                isSubValue: true
            ),
            NutrientValue(
                type: .sodium,
                value: summary[.sodium],
                isSubValue: true
            ),
            NutrientValue(
                type: .cholesterol,
                value: summary[.cholesterol],
                isSubValue: true
            )
        ]
    }
}
