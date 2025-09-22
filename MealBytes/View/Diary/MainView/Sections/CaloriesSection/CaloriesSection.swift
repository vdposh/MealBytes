//
//  CaloriesSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct CaloriesSection: View {
    let summaries: [NutrientType: Double]
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            VStack {
                VStack {
                    HStack {
                        Text("Calories")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 5) {
                            Text(
                                mainViewModel.formatter.formattedValue(
                                    summaries[.calories],
                                    unit: .empty,
                                    alwaysRoundUp: true
                                )
                            )
                            .lineLimit(1)
                            
                            if mainViewModel.canDisplayIntake() {
                                Text("/")
                                    .foregroundStyle(.secondary)
                                Text(mainViewModel.intake)
                                    .lineLimit(1)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .font(.callout)
                        .fontWeight(.medium)
                    }
                    
                    if mainViewModel.canDisplayIntake() {
                        ProgressView(value: mainViewModel.intakeProgress)
                            .progressViewStyle(.linear)
                            .background(Color.accentColor.opacity(0.2))
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                            .frame(height: 6)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                .padding(.bottom, mainViewModel.canDisplayIntake() ? 12 : 4)
                
                HStack {
                    let nutrients = mainViewModel.formattedNutrients(
                        source: .summaries(summaries)
                    )
                    ForEach(["Fat", "Carbs", "Protein"],
                            id: \.self) { key in
                        NutrientLabel(
                            label: String(key.prefix(1)),
                            formattedValue: nutrients[key] ?? ""
                        )
                    }
                    
                    if mainViewModel.canDisplayIntake() {
                        Text(mainViewModel.intakePercentageText(
                            for: summaries[.calories])
                        )
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 4)
        }
        .id(mainViewModel.displayIntake)
    }
}

#Preview {
    PreviewContentView.contentView
}
