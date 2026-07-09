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
            title: "Calories",
            value: mainViewModel.totalCalories().asWhole(unit: "cal"),
            progress: mainViewModel.canDisplayIntake() ? mainViewModel.intakeProgress : nil
        )
    }
    
    private var fatCard: some View {
        let nutrients = mainViewModel.totalNutrients()
        return GoalCard(
            title: "Fat",
            value: nutrients.fat.asWhole(unit: "g"),
            progress: nil
        )
    }
    
    private var carbsCard: some View {
        let nutrients = mainViewModel.totalNutrients()
        return GoalCard(
            title: "Carbs",
            value: nutrients.carbs.asWhole(unit: "g"),
            progress: nil
        )
    }
    
    private var proteinCard: some View {
        let nutrients = mainViewModel.totalNutrients()
        return GoalCard(
            title: "Protein",
            value: nutrients.protein.asWhole(unit: "g"),
            progress: nil
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
