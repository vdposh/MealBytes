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
                    Text("Kcal")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text(
                        formatter.formattedValue(
                            summaries[.calories] ?? 0.0,
                            unit: .empty
                        )
                    )
                    .fontWeight(.medium)
                }
                HStack {
                    NutrientLabel(
                        label: "F",
                        value: summaries[.fat] ?? 0.0,
                        formatter: formatter
                    )
                    NutrientLabel(
                        label: "P",
                        value: summaries[.protein] ?? 0.0,
                        formatter: formatter
                    )
                    .padding(.leading, 5)
                    NutrientLabel(
                        label: "C",
                        value: summaries[.carbohydrates] ?? 0.0,
                        formatter: formatter
                    )
                    .padding(.leading, 5)
                    Spacer()
                }
            }
            .padding(.vertical, 5)
        }
    }
}

#Preview {
    MainView()
}
