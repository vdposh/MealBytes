//
//  IntakeSourceView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 03/10/2026.
//

import SwiftUI

struct IntakeSourceView: View {
    @ObservedObject var goalsViewModel: GoalsViewModel
    
    var body: some View {
        Form {
            ForEach(IntakeSource.allCases, id: \.self) { source in
                SelectionRow(
                    title: source.title,
                    description: source.description,
                    isSelected: goalsViewModel.selectedIntakeSource == source
                ) {
                    goalsViewModel.selectSource(source)
                }
            }
        }
        .navigationTitle("Goal Type")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PreviewGoalsView.goalsView
}
