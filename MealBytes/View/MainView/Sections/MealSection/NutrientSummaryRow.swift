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
            let nutrientData: [(label: String, formattedValue: String)] = [
                ("F", mainViewModel.formatter.formattedValue(fats,
                                                             unit: .empty)),
                ("C", mainViewModel.formatter.formattedValue(carbs,
                                                             unit: .empty)),
                ("P", mainViewModel.formatter.formattedValue(proteins,
                                                             unit: .empty))
            ]

            ForEach(nutrientData, id: \.label) { nutrient in
                NutrientLabel(label: nutrient.label,
                              formattedValue: nutrient.formattedValue)
            }
            Spacer() //временно остается, справа будет еще одно значение
        }
    }
}

#Preview {
    MainView(mainViewModel: MainViewModel())
}
