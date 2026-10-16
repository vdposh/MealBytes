//
//  ActivitySection.swift
//  MealBytes
//
//  Created by Porshe on 08/06/2025.
//

import SwiftUI

struct ActivitySection: View {
    @ObservedObject var personalIntakeViewModel: PersonalIntakeViewModel
    
    var body: some View {
        Section {
            NavigationLink {
                ActivityView(
                    selectedActivity: $personalIntakeViewModel.selectedActivity
                )
            } label: {
                LabeledContent {
                    NotSetRow(
                        value: personalIntakeViewModel
                            .selectedActivity.rawValue
                    )
                    .lineLimit(1)
                } label: {
                    Text("Activity")
                }
            }
        }
    }
}

#Preview {
    PreviewGoalsView.goalsView
}
