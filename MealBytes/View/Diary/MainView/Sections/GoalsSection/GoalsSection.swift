//
//  CaloriesSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct GoalsSection: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            goalsBody
        } header: {
            Text("Goals")
        }
    }
    
    @ViewBuilder
    private var goalsBody: some View {
        caloriesSection
    }
    
    @ViewBuilder
    private var caloriesSection: some View {
        if mainViewModel.canDisplayIntake() {
            HStack {
                VStack(alignment: .leading, spacing: 2.5) {
                    Text("Calories")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    Text(
                        "\(mainViewModel.totalCalories().asWhole())/\(mainViewModel.currentIntake)"
                    )
                    .font(.callout)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.customCalories)
                }
                .lineLimit(1)
                .transaction { $0.animation = nil }
                
                if mainViewModel.canDisplayIntake() {
                    ActivityRingView(progress: mainViewModel.intakeProgress)
                }
            }
        } else {
            VStack(alignment: .leading, spacing: 2.5) {
                Text("Calories")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(mainViewModel.totalCalories().asWhole())
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.customCalories)
            }
            .lineLimit(1)
            .transaction { $0.animation = nil }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
