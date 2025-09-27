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
                    .padding(.bottom, dailyIntakeViewModel.toggleOn ? 0 : 10)
                
                if dailyIntakeViewModel.toggleOn {
                    Text(
                        dailyIntakeViewModel.text(
                            for: dailyIntakeViewModel.calories
                        )
                    )
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(
                        dailyIntakeViewModel.titleColor(
                            for: dailyIntakeViewModel.calories,
                            isCalorie: true
                        )
                    )
                    .padding(.top)
                    .padding(.bottom, 10)
                }
            }
        }
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
