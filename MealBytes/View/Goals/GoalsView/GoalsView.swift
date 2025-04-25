//
//  GoalsView.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

struct GoalsView: View {
    @ObservedObject var goalsViewModel: GoalsViewModel
    
    var body: some View {
        List {
            Section {
                if goalsViewModel.isDataLoaded {
                    NavigationLink(destination: RdiView()) {
                        LabeledContent {
                            Text(goalsViewModel.rdiText())
                        } label: {
                            HStack {
                                Image(systemName: "person")
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
            
            Section {
                if goalsViewModel.isDataLoaded {
                    NavigationLink(destination: CustomRdiView()) {
                        LabeledContent {
                            Text(goalsViewModel.customRdiText())
                        } label: {
                            HStack {
                                Image(systemName: "person.badge.plus")
                                    .foregroundStyle(.customGreen)
                                Text("Custom RDI")
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
                Text("RDI can be set by entering the required number of calories or calculated using macronutrient values such as fats, carbohydrates, and proteins.")
            }
        }
        .navigationBarTitle("Goals", displayMode: .inline)
        .task {
            await goalsViewModel.loadGoalsData()
        }
    }
}
