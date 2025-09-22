//
//  OverviewDailyIntakeSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct OverviewDailyIntakeSection: View {
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        Section {
        } footer: {
            VStack(alignment: .leading) {
                Text("Set daily intake by entering calories directly or calculate it based on macronutrient distribution.")
                if dailyIntakeViewModel.toggleOn {
                    Text(
                        dailyIntakeViewModel.text(
                            for: dailyIntakeViewModel.calories
                        )
                    )
                    .font(.headline)
                    .foregroundColor(
                        dailyIntakeViewModel.titleColor(
                            for: dailyIntakeViewModel.calories,
                            isCalorie: true
                        )
                    )
                    .padding(.top)
                }
            }
        }
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
