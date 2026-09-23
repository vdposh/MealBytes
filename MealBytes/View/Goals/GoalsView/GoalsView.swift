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
            PersonalIntakeSectionView(goalsViewModel: goalsViewModel)
            MacrosIntakeSectionView(goalsViewModel: goalsViewModel)
            CustomIntakeSectionView(goalsViewModel: goalsViewModel)
            
            Section {
                ForEach(
                    IntakeSource.allCases,
                    id: \.self
                ) { source in
                    SelectionRow(
                        title: source.rawValue,
                        description: source.description,
                        isSelected: goalsViewModel
                            .selectedIntakeSource == source
                    ) {
                        goalsViewModel.selectedIntakeSource = source
                    }
                }
            }
        }
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await goalsViewModel.loadGoalsData()
        }
    }
}

enum IntakeSource: String, CaseIterable {
    case personal = "Personal"
    case macros = "Macros"
    case custom = "Custom"
    
    var description: String {
        switch self {
        case .personal:
            return "Set goal based on body parameters"
        case .macros:
            return "Calculated from macronutrients"
        case .custom:
            return "Direct entry"
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
