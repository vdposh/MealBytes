//
//  CalorieMetricsSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct CalorieMetricsSection: View {
    var focus: FocusState<Bool>.Binding
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        Section {
            if dailyIntakeViewModel.toggleOn {
                Text(dailyIntakeViewModel.displayCalories)
                    .foregroundStyle(.secondary)
            } else {
                ServingTextFieldView(
                    text: $dailyIntakeViewModel.calories,
                    keyboardType: .numberPad,
                    inputMode: .integer,
                    maxIntegerDigits: 5
                )
                .foregroundStyle(
                    dailyIntakeViewModel.toggleOn ? .secondary : .primary
                )
                .focused(focus)
            }
        } header: {
            Text("Calories")
                .foregroundStyle(
                    dailyIntakeViewModel.toggleOn
                    ? .secondary
                    : dailyIntakeViewModel
                        .titleColor(for: dailyIntakeViewModel.calories)
                )
        } footer: {
            Text(dailyIntakeViewModel.toggleOn ? "Calculate calories based on macronutrient distribution." : "Set daily intake by entering calories directly.")
        }
        .id(dailyIntakeViewModel.toggleOn)
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
