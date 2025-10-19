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
            case .servingSize: value = serving.metricServingAmount
            case .fat: value = serving.fat
            case .saturatedFat: value = serving.saturatedFat
            case .monounsaturatedFat: value = serving.monounsaturatedFat
            case .polyunsaturatedFat: value = serving.polyunsaturatedFat
            case .carbohydrate: value = serving.carbohydrate
            case .sugar: value = serving.sugar
            case .fiber: value = serving.fiber
            case .protein: value = serving.protein
            case .potassium: value = serving.potassium
            case .sodium: value = serving.sodium
            case .cholesterol: value = serving.cholesterol
            }
            
            let unit = Formatter.Unit(
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
                let unit = Formatter.Unit(rawValue: type.baseUnit) ?? .empty
                
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
