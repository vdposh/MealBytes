//
//  PersonalIntakeView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

struct PersonalIntakeView: View {
    @ObservedObject var personalIntakeViewModel: PersonalIntakeViewModel
    
    var body: some View {
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

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewGoalsView.goalsView
}
