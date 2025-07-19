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
        VStack(alignment: .leading) {
            Text("Set daily intake by entering calories directly or calculate it based on macronutrient distribution.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
                .padding(.top, 40)
                .padding(.bottom, 25)
            
            Text("CALORIE METRICS")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
            
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
                    opacity: dailyIntakeViewModel.underlineOpacity,
                    maxIntegerDigits: 5
                )
                .focused(isFocused)
                .padding(.trailing, 5)
                
                Text("kcal")
                    .foregroundColor(dailyIntakeViewModel.caloriesTextColor)
                    .padding(.bottom, 2)
            }
            .id("macronutrientsField")
            .padding(.top, 12)
            .padding(.bottom)
            .padding(.horizontal, 20)
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(14)
            .padding(.horizontal, 20)
            
            Text(dailyIntakeViewModel.footerText)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 40)
        }
        .padding(.bottom, 25)
    }
}

#Preview {
    let mainViewModel = MainViewModel()
    let dailyIntakeViewModel = DailyIntakeViewModel(
        mainViewModel: mainViewModel
    )
    
    return NavigationStack {
        DailyIntakeView(dailyIntakeViewModel: dailyIntakeViewModel)
    }
}
