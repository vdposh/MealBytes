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
                value: nutrientSummaries.value(for: .calories),
                isSubValue: false
            ),
            DetailedNutrient(
                type: .fat,
                value: nutrientSummaries.value(for: .fat),
                isSubValue: false
            ),
            DetailedNutrient(
                type: .saturatedFat,
                value: nutrientSummaries.value(for: .saturatedFat),
                isSubValue: true
            ),
            DetailedNutrient(
                type: .monounsaturatedFat,
                value: nutrientSummaries.value(for: .monounsaturatedFat),
                isSubValue: true
            ),
            DetailedNutrient(
                type: .polyunsaturatedFat,
                value: nutrientSummaries.value(for: .polyunsaturatedFat),
                isSubValue: true
            ),
            DetailedNutrient(
                type: .carbohydrates,
                value: nutrientSummaries.value(for: .carbohydrates),
                isSubValue: false
            ),
            DetailedNutrient(
                type: .sugar,
                value: nutrientSummaries.value(for: .sugar),
                isSubValue: true
            ),
            DetailedNutrient(
                type: .fiber,
                value: nutrientSummaries.value(for: .fiber),
                isSubValue: true
            ),
            DetailedNutrient(
                type: .protein,
                value: nutrientSummaries.value(for: .protein),
                isSubValue: false
            ),
            DetailedNutrient(
                type: .potassium,
                value: nutrientSummaries.value(for: .potassium),
                isSubValue: true
            ),
            DetailedNutrient(
                type: .sodium,
                value: nutrientSummaries.value(for: .sodium),
                isSubValue: true
            ),
            DetailedNutrient(
                type: .cholesterol,
                value: nutrientSummaries.value(for: .cholesterol),
                isSubValue: true
            )
        ]
    }
}
