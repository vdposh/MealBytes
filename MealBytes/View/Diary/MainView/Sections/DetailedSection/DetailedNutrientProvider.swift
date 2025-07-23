//
//  DetailedNutrientProvider.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 15/03/2025.
//

import SwiftUI

struct DetailedNutrientProvider {
    func getDetailedNutrients(
        from nutrientSummaries:
        [NutrientType: Double]
    ) -> [DetailedNutrient] {
        [
            DetailedNutrient(
                type: .calories,
                value: nutrientSummaries[.calories],
                isSubValue: false
            ),
            DetailedNutrient(
                type: .fat,
                value: nutrientSummaries[.fat],
                isSubValue: false
            ),
            DetailedNutrient(
                type: .saturatedFat,
                value: nutrientSummaries[.saturatedFat],
                isSubValue: true
            ),
            DetailedNutrient(
                type: .monounsaturatedFat,
                value: nutrientSummaries[.monounsaturatedFat],
                isSubValue: true
            ),
            DetailedNutrient(
                type: .polyunsaturatedFat,
                value: nutrientSummaries[.polyunsaturatedFat],
                isSubValue: true
            ),
            DetailedNutrient(
                type: .carbohydrate,
                value: nutrientSummaries[.carbohydrate],
                isSubValue: false
            ),
            DetailedNutrient(
                type: .sugar,
                value: nutrientSummaries[.sugar],
                isSubValue: true
            ),
            DetailedNutrient(
                type: .fiber,
                value: nutrientSummaries[.fiber],
                isSubValue: true
            ),
            DetailedNutrient(
                type: .protein,
                value: nutrientSummaries[.protein],
                isSubValue: false
            ),
            DetailedNutrient(
                type: .potassium,
                value: nutrientSummaries[.potassium],
                isSubValue: true
            ),
            DetailedNutrient(
                type: .sodium,
                value: nutrientSummaries[.sodium],
                isSubValue: true
            ),
            DetailedNutrient(
                type: .cholesterol,
                value: nutrientSummaries[.cholesterol],
                isSubValue: true
            )
        ]
    }
}
