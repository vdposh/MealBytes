//
//  OverviewDailyIntakeSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct OverviewDailyIntakeSection: View {
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        Section {
            HStack {
                if dailyIntakeViewModel.isValid {
                    Text("Calories")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Text(
                    dailyIntakeViewModel
                        .text(
                            for: dailyIntakeViewModel.calories,
                            useUnit: false
                        )
                )
            }
        }
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
