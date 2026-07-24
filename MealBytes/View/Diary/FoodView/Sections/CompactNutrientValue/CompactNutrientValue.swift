//
//  CompactNutrientValue.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 10/03/2025.
//

import SwiftUI

struct CompactNutrientValue: Identifiable {
    var id: NutrientType { type }
    let type: NutrientType
    let value: Double
    let serving: Serving
    
    init(
        type: NutrientType,
        value: Double,
        serving: Serving
    ) {
        self.type = type
        self.value = value
        self.serving = serving
    }
    
    var unitDescription: String {
        let rawUnit = UnitNutrients(
            rawValue: type.unit(for: serving)
        ) ?? .empty
        let useFullName = rawUnit != .kcal
        
        return rawUnit.unitDescription(for: value, full: useFullName)
    }
    
    var formattedCompactNutrientValue: String {
        if type == .calories {
            return value.asWhole()
        } else {
            return value.asWhole()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
