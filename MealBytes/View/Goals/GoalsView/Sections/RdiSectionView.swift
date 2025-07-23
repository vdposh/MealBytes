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
                    NavigationLink(destination: RdiView(
                        rdiViewModel: rdiViewModel)
                    ) {
                        let rdiState = goalsViewModel.displayState(
                            for: .rdiView
                        )
                        
                        LabeledContent {
                            Text(rdiState.text)
                                .foregroundColor(rdiState.color)
                                .fontWeight(rdiState.weight)
                        } label: {
                            HStack {
                                Image(systemName: rdiState.icon)
                                    .foregroundStyle(.customGreen)
                                Text("RDI")
                            }
                        }
                    }
                    .disabled(!goalsViewModel.isDataLoaded)
                }
            } else {
                HStack {
                    LoadingView()
                    Text("Loading...")
                        .foregroundColor(.secondary)
                }
            }
        } footer: {
            Text("MealBytes calculates the Recommended Daily Intake (RDI) to provide a daily calorie target tailored to help achieve the desired weight.")
        }
    }
}
