//
//  WeightGoalSelection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13.08.2026.
//

import SwiftUI

struct WeightGoalSelection: View {
    @ObservedObject var rdiViewModel: RdiViewModel
    
    var body: some View {
        Section {
            NavigationLink {
                WeightGoalSelectionView(
                    selectedGoal: $rdiViewModel.selectedWeightGoal
                )
            } label: {
                LabeledContent {
                    Text(rdiViewModel.selectedWeightGoal.rawValue)
                } label: {
                    Text("Weight Goal")
                }
            }
        }
    }
}

#Preview {
    PreviewRdiView.rdiView
}
