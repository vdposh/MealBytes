//
//  ActivityView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07.08.2026.
//

import SwiftUI

struct ActivityView: View {
    @Binding var selectedActivity: Activity
    
    var body: some View {
        Form {
            ForEach(
                Activity.allCases.filter { $0 != .notSelected },
                id: \.self
            ) { activity in
                SelectionRow(
                    title: activity.rawValue,
                    description: activity.description,
                    isSelected: selectedActivity == activity
                ) {
                    selectedActivity = activity
                }
            }
        }
        .navigationTitle("Activity")
    }
}

enum Activity: String, CaseIterable {
    case notSelected = ""
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"
    case extraActive = "Extra Active"
    
    var description: String {
        switch self {
        case .notSelected:
            return ""
        case .sedentary:
            return "Little or no exercise"
        case .lightlyActive:
            return "Exercise 1-2 times a week"
        case .moderatelyActive:
            return "Exercise 3-5 times a week"
        case .veryActive:
            return "Exercise 6-7 times a week"
        case .extraActive:
            return "Very intense exercise daily or physically demanding job"
        }
    }
}

#Preview {
    PreviewRdiView.rdiView
}
