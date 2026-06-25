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
                    totalCaloriesView
                    remainingCaloriesView
                }
                .transaction { $0.animation = nil }
                
                if mainViewModel.canDisplayIntake() {
                    LinearProgressView(value: mainViewModel.intakeProgress)
                }
                
                if mainViewModel.hasMealItems {
                    macronutrientsAndPercentageView
                        .transaction { $0.animation = nil }
                }
            }
        } header: {
            Text("Goals")
        }
        .lineLimit(1)
        .id(mainViewModel.canDisplayIntake())
    }
    
    @ViewBuilder
    private var totalCaloriesView: some View {
        HStack(spacing: 5) {
            Text(mainViewModel.totalCalories().asWhole())
                .fontWeight(.medium)
            
            Text(mainViewModel.remainingCaloriesUnit)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var remainingCaloriesView: some View {
        if mainViewModel.canDisplayIntake() {
            HStack(spacing: 5) {
                Text(mainViewModel.remainingCaloriesText)
                Text(mainViewModel.remainingCaloriesWord)
            }
            .fontWeight(.medium)
            .foregroundStyle(mainViewModel.remainingCaloriesWordColor)
        }
    }
    
    private var macronutrientsAndPercentageView: some View {
        HStack {
            let totalNutrients = mainViewModel.totalNutrients()
            
            HStack {
                NutrientLabel(label: "F", value: totalNutrients.fat)
                NutrientLabel(label: "C", value: totalNutrients.carbs)
                NutrientLabel(label: "P", value: totalNutrients.protein)
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

#Preview {
    PreviewContentView.contentView
}
