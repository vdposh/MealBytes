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
        personalIntakeViewContentBody
            .navigationTitle(IntakeSource.personal.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                personalIntakeViewToolbar
            }
    }
    
    private var personalIntakeViewContentBody: some View {
        Form {
            OverviewPersonalIntakeSection(
                personalIntakeViewModel: personalIntakeViewModel
            )
            SexSection(personalIntakeViewModel: personalIntakeViewModel)
            AgeSection(personalIntakeViewModel: personalIntakeViewModel)
            WeightSection(personalIntakeViewModel: personalIntakeViewModel)
            HeightSection(personalIntakeViewModel: personalIntakeViewModel)
            ActivitySection(personalIntakeViewModel: personalIntakeViewModel)
            WeightGoalSelection(
                personalIntakeViewModel: personalIntakeViewModel
            )
        }
    }
    
    @ToolbarContentBuilder
    private var personalIntakeViewToolbar: some ToolbarContent {
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
