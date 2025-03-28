//
//  CaloriesSection.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct CaloriesSection: View {
    let summaries: [NutrientType: Double]
    @StateObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    HStack {
                        Text("Calories")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack(spacing: 5) {
                            Text(
                                mainViewModel.formatter.formattedValue(
                                    summaries[.calories] ?? 0.0,
                                    unit: .empty,
                                    alwaysRoundUp: true
                                )
                            )
                            .lineLimit(1)
                            Text("/")
                                .foregroundStyle(.secondary)
                            Text(mainViewModel.rdi)
                                .lineLimit(1)
                                .foregroundStyle(.secondary)
                        }
                        .font(.callout)
                        .fontWeight(.medium)
                    }
                    
                    ProgressView(value: mainViewModel.rdiProgress)
                        .progressViewStyle(.linear)
                        .tint(.customGreen)
                        .background(Color.customGreen.opacity(0.2))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                        .frame(height: 6)
                        .cornerRadius(4)
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
                    Text(mainViewModel.calculateRdiPercentage(
                        from: summaries[.calories] ?? 0.0))
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .trailing)
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

