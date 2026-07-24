//
//  NutrientValueProvider.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/09/2025.
//

import SwiftUI

struct NutrientValueProvider {
    func fromServing(_ serving: Serving) -> [NutrientValue] {
        NutrientType.allCases.compactMap { type in
            let value: Double?
            switch type {
            case .calories: value = serving.calories
            case .fat: value = serving.fat
            case .saturatedFat: value = serving.saturatedFat
            case .transFat: value = serving.transFat
            case .polyunsaturatedFat: value = serving.polyunsaturatedFat
            case .monounsaturatedFat: value = serving.monounsaturatedFat
            case .cholesterol: value = serving.cholesterol
            case .sodium: value = serving.sodium
            case .carbohydrate: value = serving.carbohydrate
            case .fiber: value = serving.fiber
            case .sugar: value = serving.sugar
            case .addedSugars: value = serving.addedSugars
            case .protein: value = serving.protein
            case .vitaminD: value = serving.vitaminD
            case .calcium: value = serving.calcium
            case .iron: value = serving.iron
            case .potassium: value = serving.potassium
            case .servingSize: value = serving.metricServingAmount
            }
            
            let unit = UnitNutrients(
                rawValue: type.unit(for: serving)
            ) ?? .empty
            
            return NutrientValue(
                type: type,
                value: value,
                isSubValue: type.isSubValue,
                unit: unit
            )
        }
    }
    
    func fromSummary(_ summary: [NutrientType: Double]) -> [NutrientValue] {
        NutrientType.allCases
            .filter { $0 != .servingSize }
            .map { type in
                let value = summary[type] ?? 0
                let unit = UnitNutrients(
                    rawValue: type.baseUnit
                ) ?? .empty
                
                return NutrientValue(
                    type: type,
                    value: value,
                    isSubValue: type.isSubValue,
                    unit: unit
                )
            }
    }
}

#Preview {
    PreviewContentView.contentView
}
