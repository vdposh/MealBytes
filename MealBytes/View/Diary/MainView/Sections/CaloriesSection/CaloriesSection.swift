//
//  CaloriesSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct CaloriesSection: View {
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            caloriesBody
        } header: {
            Text("Goals")
        }
    }
    
    private var caloriesBody: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2.5) {
                Text("Calories")
                    .fontWeight(.medium)
                
                if mainViewModel.canDisplayIntake() {
                    HStack(spacing: 5) {
                        Text(mainViewModel.remainingCaloriesText)
                        Text(mainViewModel.remainingCaloriesWord)
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                } else {
                    Text(mainViewModel.totalCalories().asWhole())
                        .foregroundStyle(.secondary)
                }
            }
            .lineLimit(1)
            .transaction { $0.animation = nil }
            
            if mainViewModel.canDisplayIntake() {
                ActivityRingView(progress: mainViewModel.intakeProgress)
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
