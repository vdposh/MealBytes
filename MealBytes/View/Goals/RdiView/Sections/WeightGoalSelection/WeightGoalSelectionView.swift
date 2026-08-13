//
//  WeightGoalSelectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13.08.2026.
//

import SwiftUI

struct WeightGoalSelectionView: View {
    @Binding var selectedGoal: WeightGoal
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            ForEach(
                WeightGoal.allCases.filter { $0 != .notSelected
                },
                id: \.self) { goal in
                    Button {
                        selectedGoal = goal
                    } label: {
                        VStack(alignment: .leading) {
                            Text(goal.rawValue)
                                .foregroundStyle(Color.primary)
                            
                            Text(goal.description)
                                .font(.caption)
                                .foregroundStyle(Color.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 32)
                        .overlay(alignment: .trailing) {
                            if selectedGoal == goal {
                                Image(systemName: "checkmark")
                                    .font(.headline)
                            }
                        }
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
