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
                    Text(personalIntakeViewModel.selectedActivity.rawValue)
                } label: {
                    Text("Activity")
                }
            }
        }
    }
}

#Preview {
    PreviewPersonalIntakeView.personalIntakeView
}
