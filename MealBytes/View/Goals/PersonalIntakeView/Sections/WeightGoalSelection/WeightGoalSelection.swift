//
//  WeightGoalSelection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13.08.2026.
//

import SwiftUI

struct WeightGoalSelection: View {
    @ObservedObject var personalIntakeViewModel: PersonalIntakeViewModel
    
    var body: some View {
        Section {
            NavigationLink {
                WeightGoalView(
                    selectedGoal: $personalIntakeViewModel.selectedWeightGoal
                )
            } label: {
                LabeledContent {
                    Text(personalIntakeViewModel.selectedWeightGoal.rawValue)
                } label: {
                    Text("Weight Goal")
                }
            }
        }
    }
}

#Preview {
    PreviewPersonalIntakeView.personalIntakeView
}
