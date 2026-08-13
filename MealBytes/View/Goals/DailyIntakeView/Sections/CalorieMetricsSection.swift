//
//  CalorieMetricsSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct CalorieMetricsSection: View {
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        Section {
            ServingTextFieldView(
                text: $dailyIntakeViewModel.calories,
                stackText: "Calories",
                useStackTrailing: true,
                keyboardType: .numberPad,
                inputMode: .integer,
                maxIntegerDigits: 5
            )
        }
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
