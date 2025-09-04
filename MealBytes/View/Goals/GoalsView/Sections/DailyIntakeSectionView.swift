//
//  DailyIntakeSectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/07/2025.
//

import SwiftUI

struct DailyIntakeSectionView: View {
    @ObservedObject var goalsViewModel: GoalsViewModel
    
    var body: some View {
        Section {
            if goalsViewModel.isDataLoaded {
                if let dailyIntakeViewModel = goalsViewModel
                    .dailyIntakeViewModel as? DailyIntakeViewModel {
                    NavigationLink(
                        destination: DailyIntakeView(
                            dailyIntakeViewModel: dailyIntakeViewModel
                        )
                    ) {
                        let dailyIntakeState = goalsViewModel.displayState(
                            for: .dailyIntakeView
                        )
                        
                        LabeledContent {
                            Text(dailyIntakeState.text)
                                .foregroundStyle(dailyIntakeState.color)
                                .fontWeight(dailyIntakeState.weight)
                        } label: {
                            HStack {
                                Image(systemName: dailyIntakeState.icon)
                                    .foregroundStyle(Color.accentColor)
                                Text("Daily Intake")
                            }
                        }
                    }
                    .disabled(!goalsViewModel.isDataLoaded)
                }
            } else {
                LabeledContent {
                    LoadingView(showLabel: true)
                } label: {
                    HStack {
                        Image(systemName: "person")
                            .foregroundStyle(Color.accentColor)
                        Text("Daily Intake")
                    }
                }
            }
        } footer: {
            Text("Daily intake can be set by entering the required number of calories or calculated using macronutrient values such as fats, carbohydrates, and proteins.")
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
