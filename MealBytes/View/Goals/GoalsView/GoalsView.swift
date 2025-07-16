//
//  GoalsView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

struct GoalsView: View {
    @ObservedObject var goalsViewModel: GoalsViewModel
    
    var body: some View {
        List {
            Section {
                if goalsViewModel.isDataLoaded {
                    NavigationLink(destination: DailyIntakeView(
                        dailyIntakeViewModel: goalsViewModel
                            .dailyIntakeViewModel)
                    ) {
                        let dailyIntakeState = goalsViewModel.displayState(
                            for: .dailyIntakeView
                        )
                        LabeledContent {
                            Text(dailyIntakeState.text)
                                .foregroundColor(dailyIntakeState.color)
                                .fontWeight(dailyIntakeState.weight)
                        } label: {
                            HStack {
                                Image(systemName: dailyIntakeState.icon)
                                    .foregroundStyle(.customGreen)
                                Text("Daily Intake")
                            }
                        }
                    }
                    .disabled(goalsViewModel.isDataLoaded == false)
                } else {
                    HStack {
                        LoadingView()
                        Text("Loading...")
                            .foregroundColor(.secondary)
                    }
                }
            } footer: {
                Text("Daily intake can be set by entering the required number of calories or calculated using macronutrient values such as fats, carbohydrates, and proteins.")
            }
            
            Section {
                if goalsViewModel.isDataLoaded {
                    NavigationLink(destination: RdiView(
                        rdiViewModel: goalsViewModel.rdiViewModel)
                    ) {
                        let rdiState = goalsViewModel.displayState(
                            for: .rdiView
                        )
                        LabeledContent {
                            Text(rdiState.text)
                                .foregroundColor(rdiState.color)
                                .fontWeight(rdiState.weight)
                        } label: {
                            HStack {
                                Image(systemName: rdiState.icon)
                                    .foregroundStyle(.customGreen)
                                Text("RDI")
                            }
                        }
                    }
                    .disabled(goalsViewModel.isDataLoaded == false)
                } else {
                    HStack {
                        LoadingView()
                        Text("Loading...")
                            .foregroundColor(.secondary)
                    }
                }
            } footer: {
                Text("MealBytes calculates the Recommended Daily Intake (RDI) to provide a daily calorie target tailored to help achieve the desired weight.")
            }
        }
        .id(goalsViewModel.uniqueId)
        .navigationBarTitle("Goals", displayMode: .inline)
        .task {
            await goalsViewModel.loadGoalsData()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
