//
//  DetailedNutrient.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 15/03/2025.
//

import SwiftUI

struct DetailedNutrient: Identifiable {
    var id: String {
        String(describing: type)
    }
    let type: NutrientType
    let value: Double
    let isSubValue: Bool
    
    init(type: NutrientType,
         value: Double?,
         isSubValue: Bool) {
        self.type = type
        self.value = value ?? 0.0
        self.isSubValue = isSubValue
    }
}

extension DetailedNutrient {
    var formattedValue: String {
        Formatter().formattedValue(
            value,
            unit: {
                switch type {
                case .calories: .empty
                default:
                    Formatter.Unit(rawValue: type.alternativeUnit) ?? .empty
                }
            }(),
            alwaysRoundUp: type == .calories
        )
    }
}
