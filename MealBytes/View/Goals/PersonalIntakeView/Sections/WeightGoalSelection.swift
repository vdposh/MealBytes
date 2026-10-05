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
        Picker(
            "Weight Goal",
            selection: $personalIntakeViewModel.selectedWeightGoal
        ) {
            ForEach(WeightGoal.allCases, id: \.self) { goal in
                Text(goal.rawValue).tag(goal)
            }
        }
    }
}

enum WeightGoal: String, CaseIterable {
    case lose = "Lose"
    case maintain = "Maintain"
    case gain = "Gain"
}

#Preview {
    PreviewGoalsView.goalsView
}
