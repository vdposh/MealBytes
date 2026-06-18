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
                        totalCaloriesView
                    } else {
                        emptyCaloriesView
                    }
                    
                    if mainViewModel.canDisplayIntake() {
                        remainingCaloriesView
                    }
                }
                
                if mainViewModel.canDisplayIntake() {
                    LinearProgressView(value: mainViewModel.intakeProgress)
                }
                
                if mainViewModel.hasMealItems {
                    macronutrientsAndPercentageView
                }
            }
        } header: {
            Text("Goals")
        }
        .transaction { $0.animation = nil }
        .lineLimit(1)
        .id(mainViewModel.displayIntake)
    }
    
    private var remainingCaloriesView: some View {
        HStack(spacing: 5) {
            Text(mainViewModel.remainingCaloriesText)
            Text(mainViewModel.remainingCaloriesWord)
        }
        .fontWeight(.medium)
        .foregroundStyle(mainViewModel.remainingCaloriesWordColor)
    }
    
    @ViewBuilder
    private var totalCaloriesView: some View {
        if mainViewModel.canDisplayIntake() {
            HStack(spacing: 5) {
                Text(mainViewModel.totalCalories().asWhole())
                    .fontWeight(.medium)
                
                Text(mainViewModel.remainingCaloriesUnit)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        } else {
            HStack {
                Text("Calories")
                    .font(.callout)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(mainViewModel.totalCalories().asWhole())
                    .fontWeight(.medium)
            }
        }
    }
    
    private var emptyCaloriesView: some View {
        HStack {
            Text("Calories")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("-")
        }
        .font(.callout)
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
