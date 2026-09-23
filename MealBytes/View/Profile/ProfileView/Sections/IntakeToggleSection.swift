//
//  IntakeToggleSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct IntakeToggleSection: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        Toggle(
            "Daily Intake",
            isOn: Binding(
                get: {
                    profileViewModel.mainViewModel.displayIntake
                },
                set: {
                    newValue in profileViewModel.mainViewModel
                        .setDisplayIntake(newValue)
                    Task {
                        await profileViewModel.mainViewModel
                            .saveDisplayIntakeMainView(newValue)
                    }
                }
            )
        )
        .toggleStyle(SwitchToggleStyle(tint: .accent))
    }
}

#Preview {
    PreviewContentView.contentView
}
