//
//  GoalsSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct GoalsSection: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    calorieCard
                    fatCard
                }
                HStack(spacing: 10) {
                    carbsCard
                    proteinCard
                }
            }
        } header: {
            Text("Goals")
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
        .listRowInsets(.vertical, 0)
        .listSectionMargins(.horizontal, 0)
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    // MARK: - Cards
    private var calorieCard: some View {
        GoalCard(
            title: NutrientType.calories.title,
            value: mainViewModel
                .totalCalories()
                .asWhole(unit: NutrientType.calories.unit),
            progress: mainViewModel
                .canDisplayIntake() ? mainViewModel.intakeProgress : nil
        )
    }
    
    private var fatCard: some View {
        return GoalCard(
            title: NutrientType.fat.title,
            value: mainViewModel
                .totalNutrients().fat
                .asWhole(unit: NutrientType.fat.unit),
            progress: nil
        )
    }
    
    private var carbsCard: some View {
        return GoalCard(
            title: NutrientType.carbohydrate.alternativeTitle,
            value: mainViewModel
                .totalNutrients().carbs
                .asWhole(unit: NutrientType.carbohydrate.unit),
            progress: nil
        )
    }
    
    private var proteinCard: some View {
        return GoalCard(
            title: NutrientType.protein.title,
            value: mainViewModel
                .totalNutrients().protein
                .asWhole(unit: NutrientType.protein.unit),
            progress: nil
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
