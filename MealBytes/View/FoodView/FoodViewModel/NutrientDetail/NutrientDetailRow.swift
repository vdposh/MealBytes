//
//  NutrientDetailRow.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

import SwiftUI

struct NutrientDetailRow: View {
    let nutrient: NutrientDetail

    var body: some View {
        NutrientRowView(
            title: nutrient.type.title,
            value: nutrient.formattedValue,
            isSubValue: nutrient.isSubValue
        )
    }
}
