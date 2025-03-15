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
        NutrientType.allCases
            .filter { !$0.isServingSize }
            .map { type in
                DetailedNutrient(
                    type: type,
                    value: nutrientSummaries[type] ?? 0.0,
                    isSubValue: isSubValue(nutrient: type)
                )
            }
    }
    
    private func isSubValue(nutrient: NutrientType) -> Bool {
        switch nutrient {
        case .saturatedFat,
                .monounsaturatedFat,
                .polyunsaturatedFat,
                .sugar,
                .fiber,
                .potassium,
                .sodium,
                .cholesterol:
            true
        default:
            false
        }
    }
}
