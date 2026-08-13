//
//  RdiSectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/07/2025.
//

import SwiftUI

struct RdiSectionView: View {
    @ObservedObject var goalsViewModel: GoalsViewModel
    
    var body: some View {
        Section {
            if goalsViewModel.isDataLoaded {
                if let rdiViewModel = goalsViewModel
                    .rdiViewModel as? RdiViewModel {
                    NavigationLink {
                        RdiView(rdiViewModel: rdiViewModel)
                    } label: {
                        let rdiState = goalsViewModel.displayState(
                            for: .rdiView
                        )
                        
                        LabeledContent {
                            Text(rdiViewModel.rdiText)
                                .foregroundStyle(rdiState.color)
                                .fontWeight(rdiState.weight)
                        } label: {
                            Label {
                                Text(IntakeSource.personal.rawValue)
                            } icon: {
                                Image(systemName: rdiState.icon)
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
