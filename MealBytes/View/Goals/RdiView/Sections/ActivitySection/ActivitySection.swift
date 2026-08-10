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
        NavigationLink {
            ActivitySelectionView(
                selectedActivity: $rdiViewModel.selectedActivity
            )
        } label: {
            LabeledContent {
                Text(rdiViewModel.selectedActivity.rawValue)
            } label: {
                Text("Activity")
            }
        }
    }
}

#Preview {
    PreviewRdiView.rdiView
}
