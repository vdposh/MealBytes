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
            calorieInputRow
        } header: {
            Text("Calorie Metrics")
        } footer: {
            Text(dailyIntakeViewModel.footerText)
        }
        .id("fatField")
    }
    
    private var calorieInputRow: some View {
        HStack(alignment: .bottom) {
            ServingTextFieldView(
                text: $dailyIntakeViewModel.calories,
                title: "Calories",
                showStar: dailyIntakeViewModel.showStar,
                keyboardType: .numberPad,
                inputMode: .integer,
                titleColor: dailyIntakeViewModel.titleColor(
                    for: dailyIntakeViewModel.calories,
                    isCalorie: true),
                textColor: dailyIntakeViewModel.caloriesTextColor,
                opacity: dailyIntakeViewModel.underlineOpacity,
                maxIntegerDigits: 5
            )
            .focused(isFocused)
            .padding(.trailing, 5)
            
            Text("kcal")
                .foregroundColor(dailyIntakeViewModel.caloriesTextColor)
        }
        .padding(.bottom, 5)
    }
}

#Preview {
    let loginViewModel = LoginViewModel()
    let mainViewModel = MainViewModel()
    let goalsViewModel = GoalsViewModel(mainViewModel: mainViewModel)
    
    ContentView(
        loginViewModel: loginViewModel,
        mainViewModel: mainViewModel,
        goalsViewModel: goalsViewModel
    )
    .environmentObject(ThemeManager())
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
