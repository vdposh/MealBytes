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
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(
                        mainViewModel.formatter.formattedValue(
                            summaries[.calories] ?? 0.0,
                            unit: .empty,
                            alwaysRoundUp: true
                        )
                    )
                    .lineLimit(1)
                    .font(.callout)
                    .fontWeight(.medium)
                }
                
                HStack {
                    let nutrients = mainViewModel.formattedNutrients(
                        source: .summaries(summaries)
                    )
                    ForEach(["Fat", "Carbs", "Protein"], id: \.self) { key in
                        NutrientLabel(
                            label: String(key.prefix(1)),
                            formattedValue: nutrients[key] ?? ""
                        )
                    }
                    Spacer() // временно остается, справа будет еще одно значение
                }
            }
            .padding(.vertical, 5)
        }
    }
}

#Preview {
    NavigationStack {
        MainView(mainViewModel: MainViewModel())
    }
    .accentColor(.customGreen)
}
