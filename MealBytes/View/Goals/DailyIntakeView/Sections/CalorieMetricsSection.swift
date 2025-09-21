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
        Section {
            HStack(alignment: .bottom) {
                ServingTextFieldView(
                    text: $dailyIntakeViewModel.calories,
                    title: "Calories",
                    showStar: dailyIntakeViewModel.showStar,
                    keyboardType: .numberPad,
                    inputMode: .integer,
                    titleColor: dailyIntakeViewModel.titleColor(
                        for: dailyIntakeViewModel.calories,
                        isCalorie: true
                    ),
                    textColor: dailyIntakeViewModel.caloriesTextColor,
                    maxIntegerDigits: 5
                )
                .focused(isFocused)
                .padding(.trailing, 5)
                
                Text("kcal")
                    .foregroundStyle(dailyIntakeViewModel.caloriesTextColor)
            }
            .id("macronutrientsField")
        } footer: {
            Text(dailyIntakeViewModel.footerText)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
