//
//  WeightGoalView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13.08.2026.
//

import SwiftUI

struct WeightGoalView: View {
    @Binding var selectedGoal: WeightGoal
    
    var body: some View {
        Form {
            ForEach(
                WeightGoal.allCases.filter { $0 != .notSelected
                },
                id: \.self) { goal in
                    SelectionRow(
                        title: goal.rawValue,
                        description: goal.description,
                        isSelected: selectedGoal == goal
                    ) {
                        selectedGoal = goal
                    }
                }
        }
        .navigationTitle("Weight Goal")
    }
}

enum WeightGoal: String, CaseIterable {
    case notSelected = ""
    case lose = "Lose"
    case maintain = "Maintain"
    case gain = "Gain"
    
    var description: String {
        switch self {
        case .notSelected: return ""
        case .lose: return "Calorie deficit to lose weight"
        case .maintain: return "Keep current weight"
        case .gain: return "Calorie surplus to gain weight"
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
