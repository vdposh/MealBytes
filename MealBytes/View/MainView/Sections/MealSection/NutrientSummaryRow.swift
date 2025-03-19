//
//  NutrientSummaryRow.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct NutrientSummaryRow: View {
    let fats: Double
    let carbs: Double
    let proteins: Double
    let mainViewModel: MainViewModel
    
    var body: some View {
        HStack {
            let nutrients = mainViewModel.formattedNutrients(
                source: .details(fats: fats, carbs: carbs, proteins: proteins)
            )
            NutrientLabel(label: "F", formattedValue: nutrients.fat)
            NutrientLabel(label: "C", formattedValue: nutrients.carb)
            NutrientLabel(label: "P", formattedValue: nutrients.protein)
            Spacer() //временно остается, справа будет еще одно значение
        }
    }
}
