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
        OverviewIntake(
            valueText: dailyIntakeViewModel.text(for: dailyIntakeViewModel.calories),
            color: dailyIntakeViewModel.titleColor(
                for: dailyIntakeViewModel.calories,
                isCalorie: true
            ),
            footerText: "Set daily intake by entering calories directly or calculate it based on macronutrient distribution.",
            showValue: dailyIntakeViewModel.toggleOn
        )
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
