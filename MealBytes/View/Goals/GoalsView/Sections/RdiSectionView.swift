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
                            Text(rdiState.text)
                                .foregroundStyle(rdiState.color)
                                .fontWeight(rdiState.weight)
                        } label: {
                            Label {
                                Text("RDI")
                            } icon: {
                                Image(systemName: rdiState.icon)
                                    .foregroundStyle(.accent)
                            }
                        }
                    }
                    .disabled(!goalsViewModel.isDataLoaded)
                }
            } else {
                LabeledContent {
                    LoadingView(showLabel: true)
                } label: {
                    Label {
                        Text("RDI")
                    } icon: {
                        Image(systemName: "person")
                            .foregroundStyle(.accent)
                    }
                }
            }
        } footer: {
            Text("MealBytes calculates the Recommended Daily Intake (RDI) to provide a daily calorie target tailored to help achieve the desired weight.")
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
