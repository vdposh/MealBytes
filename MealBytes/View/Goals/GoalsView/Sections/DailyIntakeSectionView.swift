//
//  DailyIntakeSectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/07/2025.
//

import SwiftUI

struct DailyIntakeSectionView: View {
    @ObservedObject var goalsViewModel: GoalsViewModel
    
    var body: some View {
        Section {
            if goalsViewModel.isDataLoaded {
                if let dailyIntakeViewModel = goalsViewModel
                    .dailyIntakeViewModel as? DailyIntakeViewModel {
                    NavigationLink {
                        DailyIntakeView(
                            dailyIntakeViewModel: dailyIntakeViewModel
                        )
                    } label: {
                        let dailyIntakeState = goalsViewModel.displayState(
                            for: .dailyIntakeView
                        )
                        
                        LabeledContent {
                            Text(dailyIntakeViewModel.dailyIntakeText)
                                .foregroundStyle(dailyIntakeState.color)
                                .fontWeight(dailyIntakeState.weight)
                        } label: {
                            Label {
                                Text(IntakeSource.macros.rawValue)
                            } icon: {
                                Image(systemName: dailyIntakeState.icon)
                                    .foregroundStyle(.accent)
                            }
                        }
                        .labelIconToTitleSpacing(10)
                    }
                    .disabled(!goalsViewModel.isDataLoaded)
                }
            } else {
                LabeledContent {
                    LoadingView(showLabel: true)
                } label: {
                    Label {
                        Text(IntakeSource.macros.rawValue)
                    } icon: {
                        Image(systemName: "person")
                            .foregroundStyle(.accent)
                    }
                }
                .labelIconToTitleSpacing(10)
            }
        } footer: {
            Text(IntakeSource.macros.description)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
