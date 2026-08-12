//
//  CustomIntakeSectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 12.08.2026.
//

import SwiftUI

struct CustomIntakeSectionView: View {
    @ObservedObject var goalsViewModel: GoalsViewModel
    
    var body: some View {
        Section {
            if goalsViewModel.isDataLoaded {
                if let customIntakeViewModel = goalsViewModel
                    .customIntakeViewModel as? CustomIntakeViewModel {
                    NavigationLink {
                        CustomIntakeView(
                            customIntakeViewModel: customIntakeViewModel
                        )
                    } label: {
                        let customIntakeState = goalsViewModel.displayState(
                            for: .customView
                        )
                        
                        LabeledContent {
                            Text(customIntakeViewModel.text)
                                .foregroundStyle(customIntakeState.color)
                                .fontWeight(customIntakeState.weight)
                        } label: {
                            Label {
                                Text("Custom Intake")
                            } icon: {
                                Image(systemName: customIntakeState.icon)
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
                        Text("Custom Intake")
                    } icon: {
                        Image(systemName: "pencil")
                            .foregroundStyle(.accent)
                    }
                }
                .labelIconToTitleSpacing(10)
            }
        } footer: {
            Text("Set daily intake by entering calories directly.")
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
