//
//  CalorieMetricsSection.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI

struct CalorieMetricsSection: View {
    @FocusState var focusedField: CustomRdiFocus?
    @ObservedObject var customRdiViewModel: CustomRdiViewModel
    
    var body: some View {
        Section {
            VStack {
                calorieInputRow
            }
            .padding(.bottom, 5)
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
                keyboardType: .decimalPad,
                titleColor: customRdiViewModel.titleColor(
                    for: customRdiViewModel.calories,
                    isCalorie: true),
                textColor: customRdiViewModel.caloriesTextColor
            )
            .focused($focusedField, equals: .calories)
            .padding(.trailing, 5)
            
            Text("kcal")
                .foregroundColor(customRdiViewModel.caloriesTextColor)
        }
    }
}

enum CustomRdiFocus: Hashable {
    case calories
}

#Preview {
    NavigationStack {
        CustomRdiView()
    }
}
