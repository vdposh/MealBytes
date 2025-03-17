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
                    Spacer()
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
                    let nutrientTypes: [(label: String, value: String)] = [
                        ("F", mainViewModel.formatter.formattedValue(
                            summaries[.fat] ?? 0.0, unit: .empty)),
                        ("C", mainViewModel.formatter.formattedValue(
                            summaries[.carbohydrates] ?? 0.0, unit: .empty)),
                        ("P", mainViewModel.formatter.formattedValue(
                            summaries[.protein] ?? 0.0, unit: .empty))
                    ]
                    
                    ForEach(nutrientTypes, id: \.label) { nutrient in
                        NutrientLabel(
                            label: nutrient.label,
                            formattedValue: nutrient.value
                        )
                    }
                    Spacer()
                }
            }
            .padding(.vertical, 5)
        }
    }
}
