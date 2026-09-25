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
                        
                        Label {
                            Text(IntakeSource.personal.rawValue)
                        } icon: {
                            Image(systemName: personalIntakeState.icon)
                                .foregroundStyle(.accent)
                        }
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
            }
        } footer: {
            Text(IntakeSource.personal.description)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
