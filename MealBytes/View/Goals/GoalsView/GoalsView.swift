//
//  GoalsView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

struct GoalsView: View {
    @ObservedObject var goalsViewModel: GoalsViewModel
    
    var body: some View {
        Form {
            DailyIntakeSectionView(goalsViewModel: goalsViewModel)
            RdiSectionView(goalsViewModel: goalsViewModel)
            DisclaimerButtonSection()
        }
        .id(goalsViewModel.uniqueId)
        .navigationBarTitle("Goals", displayMode: .inline)
        .task {
            await goalsViewModel.loadGoalsData()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
