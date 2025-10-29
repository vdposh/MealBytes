//
//  CalorieMetricsSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct CalorieMetricsSection: View {
    var isFocused: FocusState<Bool>.Binding
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        if !dailyIntakeViewModel.toggleOn {
            Section {
                HStack {
                    ServingTextFieldView(
                        text: $dailyIntakeViewModel.calories,
                        placeholder: "Calories amount",
                        keyboardType: .numberPad,
                        inputMode: .integer,
                        maxIntegerDigits: 5
                    )
                    .focused(isFocused)
                }
            } header: {
                Text("Calories")
                    .foregroundStyle(
                        dailyIntakeViewModel
                            .titleColor(for: dailyIntakeViewModel.calories))
            } footer: {
                Text("Necessary calorie amount can be entered directly.")
            }
        }
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
