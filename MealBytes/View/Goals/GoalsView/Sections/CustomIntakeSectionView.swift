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
                        
                        Label {
                            Text(IntakeSource.custom.rawValue)
                        } icon: {
                            Image(systemName: customIntakeState.icon)
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
                        Text(IntakeSource.custom.rawValue)
                    } icon: {
                        Image(systemName: "person")
                            .foregroundStyle(.accent)
                    }
                }
            }
        } footer: {
            Text(IntakeSource.custom.description)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
