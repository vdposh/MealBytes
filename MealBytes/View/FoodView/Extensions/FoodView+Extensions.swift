//
//  FoodView+Extensions.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

extension FoodView {
    func nutrientBlockView(title: String,
                           value: Double?,
                           unit: String,
                           amountValue: Double) -> some View {
        NutrientBlockView(
            title: title,
            value: (value ?? 0) * amountValue,
            unit: unit
        )
    }

    func nutrientDetailRow(title: String,
                           value: Double?,
                           unit: String,
                           amountValue: Double,
                           isSubValue: Bool = false) -> some View {
        NutrientDetailRow(
            title: title,
            value: (value ?? 0) * amountValue,
            unit: unit,
            isSubValue: isSubValue
        )
    }
}
