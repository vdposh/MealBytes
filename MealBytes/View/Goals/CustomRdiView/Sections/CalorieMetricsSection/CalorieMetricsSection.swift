//
//  CalorieMetricsSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct CalorieMetricsSection: View {
    @FocusState var focusedField: CustomRdiFocus?
    @ObservedObject var customRdiViewModel: CustomRdiViewModel
    
    var body: some View {
        Section {
            calorieInputRow
        } header: {
            Text("Calorie Metrics")
        } footer: {
            Text(customRdiViewModel.footerText)
        }
    }
    
    private var calorieInputRow: some View {
        HStack(alignment: .bottom) {
            ServingTextFieldView(
                text: $customRdiViewModel.calories,
                title: "Calories",
                showStar: customRdiViewModel.showStar,
                keyboardType: .numberPad,
                titleColor: customRdiViewModel.titleColor(
                    for: customRdiViewModel.calories,
                    isCalorie: true),
                textColor: customRdiViewModel.caloriesTextColor,
                opacity: customRdiViewModel.underlineOpacity,
                maxIntegerDigits: 5
            )
            .focused($focusedField, equals: .calories)
            .padding(.trailing, 5)
            
            Text("kcal")
                .foregroundColor(customRdiViewModel.caloriesTextColor)
        }
        .padding(.bottom, 5)
    }
}

enum CustomRdiFocus: Hashable {
    case calories
}

#Preview {
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel(),
        goalsViewModel: GoalsViewModel()
    )
    .environmentObject(ThemeManager())
}

#Preview {
    NavigationStack {
        CustomRdiView()
    }
}
