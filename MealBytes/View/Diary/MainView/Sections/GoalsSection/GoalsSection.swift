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
            .listRowInsets(.all, 0)
        } header: {
            HeaderButtonView(
                title: "Goals",
                isEdit: true
            ) {
                mainViewModel.showGoals = true
            }
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
    }
    
    // MARK: - Cards
    private var calorieCard: some View {
        GoalCard(
            title: NutrientType.calories.title,
            value: mainViewModel
                .totalCalories()
                .asWhole(unit: NutrientType.calories.unitType.rawValue),
            progress: mainViewModel.calorieProgress()
        )
    }
    
    private var fatCard: some View {
        GoalCard(
            title: NutrientType.fat.title,
            value: mainViewModel
                .totalNutrients().fat
                .asWhole(unit: NutrientType.fat.unitType.rawValue),
            progress: mainViewModel.macroProgress(for: .fat),
            color: .customFat
        )
    }
    
    private var carbsCard: some View {
        GoalCard(
            title: NutrientType.carbohydrate.alternativeTitle,
            value: mainViewModel
                .totalNutrients().carbs
                .asWhole(unit: NutrientType.carbohydrate.unitType.rawValue),
            progress: mainViewModel.macroProgress(for: .carbohydrate),
            color: .customCarbs
        )
    }
    
    private var proteinCard: some View {
        GoalCard(
            title: NutrientType.protein.title,
            value: mainViewModel
                .totalNutrients().protein
                .asWhole(unit: NutrientType.protein.unitType.rawValue),
            progress: mainViewModel.macroProgress(for: .protein),
            color: .customProtein
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
