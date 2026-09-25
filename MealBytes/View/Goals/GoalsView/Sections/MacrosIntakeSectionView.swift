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
                        
                        Label {
                            Text(IntakeSource.macros.rawValue)
                        } icon: {
                            Image(systemName: macrosIntakeState.icon)
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
                        Text(IntakeSource.macros.rawValue)
                    } icon: {
                        Image(systemName: "person")
                            .foregroundStyle(.accent)
                    }
                }
            }
        } footer: {
            Text(IntakeSource.macros.description)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
