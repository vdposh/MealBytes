//
//  GoalsToggleSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 07.10.2026.
//

import SwiftUI

struct GoalsToggleSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Section {
            Toggle("Goals", isOn: Binding(
                get: { profileViewModel.displayGoals },
                set: { newValue in
                    Task {
                        await profileViewModel.setDisplayGoals(newValue)
                    }
                }
            ))
        } footer: {
            Text("Enable to show Goal Cards in the Diary.")
        }
    }
}

#Preview {
    PreviewProfileView.profileView
}
