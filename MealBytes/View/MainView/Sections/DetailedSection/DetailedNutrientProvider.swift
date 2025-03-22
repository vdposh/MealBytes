//
//  DetailedNutrientProvider.swift
//  MealBytes
//
//  Created by Porshe on 15/03/2025.
//

import SwiftUI

struct DetailedNutrientProvider {
    func getDetailedNutrients(from nutrientSummaries:
                              [NutrientType: Double]) -> [DetailedNutrient] {
        [
            DetailedNutrient(
                type: .calories,
                value: nutrientSummaries[.calories] ?? 0.0,
                isSubValue: false
            ),
            DetailedNutrient(
                type: .fat,
                value: nutrientSummaries[.fat] ?? 0.0,
                isSubValue: false
            ),
            DetailedNutrient(
                type: .saturatedFat,
                value: nutrientSummaries[.saturatedFat] ?? 0.0,
                isSubValue: true
            ),
            DetailedNutrient(
                type: .monounsaturatedFat,
                value: nutrientSummaries[.monounsaturatedFat] ?? 0.0,
                isSubValue: true
            ),
            DetailedNutrient(
                type: .polyunsaturatedFat,
                value: nutrientSummaries[.polyunsaturatedFat] ?? 0.0,
                isSubValue: true
            ),
            DetailedNutrient(
                type: .carbohydrate,
                value: nutrientSummaries[.carbohydrate] ?? 0.0,
                isSubValue: false
            ),
            DetailedNutrient(
                type: .sugar,
                value: nutrientSummaries[.sugar] ?? 0.0,
                isSubValue: true
            ),
            DetailedNutrient(
                type: .fiber,
                value: nutrientSummaries[.fiber] ?? 0.0,
                isSubValue: true
            ),
            DetailedNutrient(
                type: .protein,
                value: nutrientSummaries[.protein] ?? 0.0,
                isSubValue: false
            ),
            DetailedNutrient(
                type: .potassium,
                value: nutrientSummaries[.potassium] ?? 0.0,
                isSubValue: true
            ),
            DetailedNutrient(
                type: .sodium,
                value: nutrientSummaries[.sodium] ?? 0.0,
                isSubValue: true
            ),
            DetailedNutrient(
                type: .cholesterol,
                value: nutrientSummaries[.cholesterol] ?? 0.0,
                isSubValue: true
            )
        ]
    }
}
