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
            
            Section {
                ForEach(
                    IntakeSource.allCases,
                    id: \.self
                ) { source in
                    Button {
                        goalsViewModel.selectedIntakeSource = source
                    } label: {
                        VStack(alignment: .leading) {
                            Text(source.title)
                                .foregroundStyle(Color.primary)
                            
                            Text(source.description)
                                .font(.caption)
                                .foregroundStyle(Color.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 32)
                        .overlay(alignment: .leading) {
                            if goalsViewModel.selectedIntakeSource == source {
                                Image(systemName: "checkmark")
                                    .font(.headline)
                            }
                        }
                    }
                }
            }
        }
        .id(goalsViewModel.uniqueId)
        .navigationTitle("Goals")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await goalsViewModel.loadGoalsData()
        }
    }
}

enum IntakeSource: String, CaseIterable {
    case rdi = "RDI"
    case macros = "Macros"
    case custom = "Custom"
    
    var title: String {
        switch self {
        case .rdi: return "Personal"
        case .macros: return "Macros"
        case .custom: return "Custom"
        }
    }
    
    var description: String {
        switch self {
        case .rdi:
            return "Based on unique factors"
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
