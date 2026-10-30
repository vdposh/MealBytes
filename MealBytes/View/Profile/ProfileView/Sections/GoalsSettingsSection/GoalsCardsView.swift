//
//  GoalsCardsView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16.10.2026.
//

import SwiftUI

struct GoalsCardsView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Toggle(isOn: Binding(
            get: { profileViewModel.displayGoals },
            set: { newValue in
                Task {
                    await profileViewModel.setDisplayGoals(newValue)
                }
            }
        )) {
            Text("Cards")
        }
        .toggleStyle(SwitchToggleStyle(tint: .accent))
    }
}

#Preview {
    PreviewProfileView.profileView
}
