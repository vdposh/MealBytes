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
            caloriesBody
        } header: {
            Text("Goals")
        }
    }
    
    private var caloriesBody: some View {
        VStack(spacing: 10) {
            HStack {
                totalCaloriesView
                remainingCaloriesView
            }
            .transaction { $0.animation = nil }
            
            if mainViewModel.canDisplayIntake() {
                LinearProgressView(value: mainViewModel.intakeProgress)
            }
            
            macronutrientsAndPercentageView
        }
        .lineLimit(1)
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
    
    @ViewBuilder
    private var macronutrientsAndPercentageView: some View {
        if mainViewModel.hasMealItems {
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
            .transaction { $0.animation = nil }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
