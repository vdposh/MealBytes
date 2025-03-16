//
//  DetailedNutrientRow.swift
//  MealBytes
//
//  Created by Porshe on 15/03/2025.
//

import SwiftUI

//MARK: - Displays a single row in the UI for a specific nutrient, showing its type and formatted value
struct DetailedNutrientRow: View {
    let nutrient: DetailedNutrient

    var body: some View {
        NutrientRowView(
            title: nutrient.type.title,
            value: nutrient.formattedValue,
            isSubValue: nutrient.isSubValue
        )
    }
}

#Preview {
    MainView()
}
