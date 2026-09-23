//
//  MacrosIntakeSectionView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/07/2025.
//

import SwiftUI

struct MacrosIntakeSectionView: View {
    @ObservedObject var goalsViewModel: GoalsViewModel
    
    var body: some View {
        Section {
            if goalsViewModel.isDataLoaded {
                if let macrosIntakeViewModel = goalsViewModel
                    .macrosIntakeViewModel as? MacrosIntakeViewModel {
                    NavigationLink {
                        MacrosIntakeView(
                            macrosIntakeViewModel: macrosIntakeViewModel
                        )
                    } label: {
                        let macrosIntakeState = goalsViewModel.displayState(
                            for: .macrosIntakeView
                        )
                        
                        LabeledContent {
                            Text(macrosIntakeViewModel.macrosIntakeText)
                                .foregroundStyle(macrosIntakeState.color)
                                .fontWeight(macrosIntakeState.weight)
                        } label: {
                            Label {
                                Text(IntakeSource.macros.rawValue)
                            } icon: {
                                Image(systemName: macrosIntakeState.icon)
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
