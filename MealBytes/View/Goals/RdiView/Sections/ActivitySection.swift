//
//  ActivitySection.swift
//  MealBytes
//
//  Created by Porshe on 08/06/2025.
//

import SwiftUI

struct ActivitySection: View {
    @ObservedObject var rdiViewModel: RdiViewModel

    var body: some View {
        Section {
            Picker(
                "Activity",
                selection: $rdiViewModel.selectedActivity
            ) {
                if rdiViewModel.selectedActivity == .notSelected {
                    Text("Not Selected").tag(Activity.notSelected)
                }
                ForEach(
                    Activity.allCases.filter { $0 != .notSelected },
                    id: \.self
                ) { level in
                    Text(level.rawValue).tag(level)
                }
            }
            .pickerStyle(.menu)
            .tint(rdiViewModel.selectedActivity.selectedColor)
        } footer: {
            Text("Select the necessary indicator based on daily activity level.")
        }
        .id("ageField")
    }
}

enum Activity: String, CaseIterable {
    case notSelected = "Not selected"
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"
    case extraActive = "Extra Active"
    
    var selectedColor: Color {
        switch self {
        case .notSelected: return .customRed
        default: return .accent
        }
    }
}

#Preview {
    PreviewRdiView.rdiView
}
