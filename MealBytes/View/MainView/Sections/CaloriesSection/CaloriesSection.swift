//
//  CaloriesSection.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct CaloriesSection: View {
    let summaries: [NutrientType: Double]
    let formatter: Formatter

    var body: some View {
        Section {
            VStack(spacing: 10) {
                HStack {
                    Text("Calories")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(
                        formatter.formattedValue(
                            summaries[.calories] ?? 0.0,
                            unit: .empty,
                            alwaysRoundUp: true
                        )
                    )
                    .fontWeight(.medium)
                }
                HStack {
                    let nutrientTypes: [(label: String, type: NutrientType)] = [
                        ("F", .fat),
                        ("C", .carbohydrates),
                        ("P", .protein)
                    ]
                    
                    ForEach(nutrientTypes, id: \.label) { nutrient in
                        NutrientLabel(
                            label: nutrient.label,
                            value: summaries[nutrient.type] ?? 0.0,
                            formatter: formatter
                        )
                    }
                    Spacer()
                }
            }
            .padding(.vertical, 5)
        }
    }
}
