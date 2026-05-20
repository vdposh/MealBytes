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
            VStack(spacing: 10) {
                HStack {
                    if mainViewModel.hasMealItems {
                        HStack(alignment: .lastTextBaseline, spacing: 5) {
                            Text(mainViewModel.totalCalories().asWhole())
                                .fontWeight(.medium)
                            
                            Text(mainViewModel.remainingCaloriesUnit)
                                .foregroundStyle(.secondary)
                        }
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    } else {
                        HStack {
                            Text("Calories")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("-")
                        }
                        .font(.callout)
                    }
                    
                    if mainViewModel.canDisplayIntake() {
                        HStack(alignment: .lastTextBaseline, spacing: 5) {
                            Text(mainViewModel.remainingCaloriesText)
                            Text(mainViewModel.remainingCaloriesWord)
                        }
                        .font(.callout)
                        .fontWeight(.medium)
                        .foregroundStyle(
                            mainViewModel.remainingCaloriesWordColor
                        )
                    }
                }
                
                if mainViewModel.canDisplayIntake() {
                    LinearProgressView(value: mainViewModel.intakeProgress)
                }
                
                if mainViewModel.hasMealItems {
                    HStack {
                        let totalNutrients = mainViewModel
                            .totalNutrients()
                        
                        HStack(spacing: 10) {
                            NutrientLabel(
                                label: "F",
                                value: totalNutrients.fat
                            )
                            NutrientLabel(
                                label: "C",
                                value: totalNutrients.carbs
                            )
                            NutrientLabel(
                                label: "P",
                                value: totalNutrients.protein
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if mainViewModel.canDisplayIntake() {
                            Text(mainViewModel.totalIntakePercentage())
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                        }
                    }
                }
            }
            .transaction { $0.animation = nil }
            .lineLimit(1)
        }
        .id(mainViewModel.displayIntake)
    }
}

#Preview {
    PreviewContentView.contentView
}
