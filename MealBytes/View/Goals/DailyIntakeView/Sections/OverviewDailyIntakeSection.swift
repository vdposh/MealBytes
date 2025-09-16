//
//  OverviewDailyIntakeSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct OverviewDailyIntakeSection: View {
    
    var body: some View {
        SectionStyleView(
            mainContent: {
                EmptyView()
            },
            title: "Set daily intake by entering calories directly or calculate it based on macronutrient distribution."
        )
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
