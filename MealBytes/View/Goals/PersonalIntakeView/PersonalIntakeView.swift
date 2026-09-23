//
//  PersonalIntakeView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

struct PersonalIntakeView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var personalIntakeViewModel: PersonalIntakeViewModel
    
    var body: some View {
        PersonalIntakeViewContentBody
            .navigationTitle(IntakeSource.personal.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                PersonalIntakeViewToolbar
            }
    }
    
    private var PersonalIntakeViewContentBody: some View {
        Form {
            OverviewPersonalIntakeSection(
                personalIntakeViewModel: personalIntakeViewModel
            )
            BodyProfileSection(
                personalIntakeViewModel: personalIntakeViewModel
            )
            WeightSection(personalIntakeViewModel: personalIntakeViewModel)
            HeightSection(personalIntakeViewModel: personalIntakeViewModel)
            ActivitySection(personalIntakeViewModel: personalIntakeViewModel)
            WeightGoalSelection(
                personalIntakeViewModel: personalIntakeViewModel
            )
        }
    }
    
    @ToolbarContentBuilder
    private var PersonalIntakeViewToolbar: some ToolbarContent {
        ToolbarItem {
            Button(role: .confirm) {
                Task {
                    await personalIntakeViewModel.savePersonalIntakeView()
                }
                
                dismiss()
            }
            .disabled(!personalIntakeViewModel.isValid)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewPersonalIntakeView.personalIntakeView
}
