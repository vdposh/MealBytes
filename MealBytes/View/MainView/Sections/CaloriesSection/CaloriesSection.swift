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
                            summaries.value(for: .calories),
                            unit: .empty,
                            alwaysRoundUp: true
                        )
                    )
                    .fontWeight(.medium)
                }
                HStack {
                    NutrientLabel(
                        label: "F",
                        value: summaries.value(for: .fat),
                        formatter: formatter
                    )
                    NutrientLabel(
                        label: "C",
                        value: summaries.value(for: .carbohydrates),
                        formatter: formatter
                    )
                    NutrientLabel(
                        label: "P",
                        value: summaries.value(for: .protein),
                        formatter: formatter
                    )
                    Spacer()
                }
            }
            .padding(.vertical, 5)
        }
    }
}
