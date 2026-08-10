//
//  ActivitySelectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07.08.2026.
//

import SwiftUI

struct ActivitySelectionView: View {
    @Binding var selectedActivity: Activity
    
    var body: some View {
        Form {
            ForEach(
                Activity.allCases.filter { $0 != .notSelected
                },
                id: \.self) { activity in
                    Button {
                        selectedActivity = activity
                    } label: {
                        VStack(alignment: .leading) {
                            Text(activity.rawValue)
                                .foregroundStyle(Color.primary)
                            
                            Text(activity.description)
                                .font(.caption)
                                .foregroundStyle(Color.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.trailing, 32)
                        .overlay(alignment: .trailing) {
                            if selectedActivity == activity {
                                Image(systemName: "checkmark")
                                    .font(.headline)
                            }
                        }
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
