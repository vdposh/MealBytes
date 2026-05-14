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
                    Text("Calories")
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 5) {
                        Text(mainViewModel.totalCaloriesForAllMeals())
                        
                        if mainViewModel.canDisplayIntake() {
                            Text("/")
                                .foregroundStyle(.secondary)
                            Text(mainViewModel.intake)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .layoutPriority(1)
                    .font(.callout)
                    .fontWeight(.medium)
                }
                
                if mainViewModel.hasMealItems {
                    if mainViewModel.canDisplayIntake() {
                        Gauge(value: mainViewModel.intakeProgress) { }
                            .gaugeStyle(.accessoryLinear)
                            .tint(Gradient.progressGradientOrange)
                    }
                    
                    HStack {
                        let totalNutrientsForAllMeals = mainViewModel
                            .totalNutrientsForAllMeals()
                        
                        HStack {
                            NutrientLabel(
                                label: "F",
                                formattedValue: mainViewModel.formatter
                                    .formattedValue(
                                        totalNutrientsForAllMeals.fat,
                                        unit: .empty
                                    )
                            )
                            NutrientLabel(
                                label: "C",
                                formattedValue: mainViewModel.formatter
                                    .formattedValue(
                                        totalNutrientsForAllMeals.carbs,
                                        unit: .empty
                                    )
                            )
                            NutrientLabel(
                                label: "P",
                                formattedValue: mainViewModel.formatter
                                    .formattedValue(
                                        totalNutrientsForAllMeals.protein,
                                        unit: .empty
                                    )
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if mainViewModel.canDisplayIntake() {
                            Text(
                                mainViewModel.totalIntakePercentageForAllMeals()
                            )
                            .foregroundStyle(.secondary)
                            .font(.subheadline)
                        }
                    }
                }
            }
            .transaction { $0.animation = nil }
            .lineLimit(1)
        } header: {
            dateSection
        }
        .id(mainViewModel.displayIntake)
    }
    
    private var dateSection: some View {
        HStack {
            ForEach(-3...3, id: \.self) { offset in
                let date = mainViewModel.dateByAddingOffset(for: offset)
                
                Button {
                    withAnimation {
                        mainViewModel.date = date
                    }
                } label: {
                    DateView(
                        date: date,
                        isToday: Calendar.current.isDate(
                            date,
                            inSameDayAs: Date()
                        ),
                        isSelected: Calendar.current.isDate(
                            date,
                            inSameDayAs: mainViewModel.date
                        ),
                        mainViewModel: mainViewModel
                    )
                }
                .buttonStyle(.plain)
            }
        }
        .transaction { $0.animation = nil }
        .listRowInsets(
            EdgeInsets(top: 20, leading: 0, bottom: 16, trailing: 0)
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
