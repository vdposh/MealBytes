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
        let rawUnit = Formatter.Unit(
            rawValue: type.unit(for: serving)
        ) ?? .empty
        let useFullName = rawUnit != .kcal
        return rawUnit.description(for: value, full: useFullName)
    }
    
    var formattedCompactNutrientValue: String {
        Formatter().formattedValue(
            value,
            unit: .empty,
            alwaysRoundUp: type == .calories)
    }
}

#Preview {
    PreviewContentView.contentView
}
