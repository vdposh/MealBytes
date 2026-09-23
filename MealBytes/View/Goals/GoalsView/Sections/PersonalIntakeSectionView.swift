//
//  PersonalIntakeSectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/07/2025.
//

import SwiftUI

struct PersonalIntakeSectionView: View {
    @ObservedObject var goalsViewModel: GoalsViewModel
    
    var body: some View {
        Section {
            if goalsViewModel.isDataLoaded {
                if let personalIntakeViewModel = goalsViewModel
                    .personalIntakeViewModel as? PersonalIntakeViewModel {
                    NavigationLink {
                        PersonalIntakeView(
                            personalIntakeViewModel: personalIntakeViewModel
                        )
                    } label: {
                        let personalIntakeState = goalsViewModel.displayState(
                            for: .personalIntakeView
                        )
                        
                        LabeledContent {
                            Text(personalIntakeViewModel.personalIntakeText)
                                .foregroundStyle(personalIntakeState.color)
                                .fontWeight(personalIntakeState.weight)
                        } label: {
                            Label {
                                Text(IntakeSource.personal.rawValue)
                            } icon: {
                                Image(systemName: personalIntakeState.icon)
                                    .foregroundStyle(.accent)
                            }
                        }
                        .labelIconToTitleSpacing(10)
                    }
                    .disabled(!goalsViewModel.isDataLoaded)
                }
            } else {
                LabeledContent {
                    LoadingView()
                } label: {
                    Label {
                        Text(IntakeSource.personal.rawValue)
                    } icon: {
                        Image(systemName: "person")
                            .foregroundStyle(.accent)
                    }
                }
                .labelIconToTitleSpacing(10)
            }
        } footer: {
            Text(IntakeSource.personal.description)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
