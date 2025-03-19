//
//  CaloriesSection.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct CaloriesSection: View {
    let summaries: [NutrientType: Double]
    let mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            VStack(spacing: 10) {
                HStack {
                    Text("Calories")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(
                        mainViewModel.formatter.formattedValue(
                            summaries[.calories] ?? 0.0,
                            unit: .empty,
                            alwaysRoundUp: true
                        )
                    )
                    .fontWeight(.medium)
                }
                
                HStack {
                    let nutrients = mainViewModel.formattedNutrients(
                        source: .summaries(summaries)
                    )
                    NutrientLabel(label: "F", formattedValue: nutrients.fat)
                    NutrientLabel(label: "C", formattedValue: nutrients.carb)
                    NutrientLabel(label: "P", formattedValue: nutrients.protein)
                    Spacer() //временно остается, справа будет еще одно значение
                }
            }
            .padding(.vertical, 5)
        }
    }
}
