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
        ZStack {
            if !goalsViewModel.isDataLoaded {
                LoadingView()
                    .navigationBarTitle("Goals", displayMode: .inline)
            } else {
                List {
                    Section {
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
                    } footer: {
                        Text("MealBytes calculates your Recommended Daily Intake (RDI) to provide you with a daily calorie target tailored to help you achieve your desired weight.")
                    }
                    
                    Section {
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
                    } footer: {
                        Text("You can also calculate your RDI manually by entering calories and macronutrient values such as fats, carbohydrates and proteins.")
                    }
                }
                .navigationBarTitle("Goals", displayMode: .inline)
                .task {
                    await goalsViewModel.loadProfileData()
                }
            }
        }
    }
}
