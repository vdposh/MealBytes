//
//  CalorieMetricsSection.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI

struct CalorieMetricsSection: View {
    @FocusState var focusedField: Bool
    @ObservedObject var customRdiViewModel: CustomRdiViewModel
    
    var body: some View {
        Section(header: Text("Calorie Metrics")) {
            VStack {
                calorieInputRow
            }
            .padding(.bottom, 5)
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
                    for: customRdiViewModel.calories),
                textColor: customRdiViewModel.caloriesTextColor
            )
            .focused($focusedField)
            .disabled(customRdiViewModel.toggleOn)
            .padding(.trailing, 5)
            
            Text("kcal")
                .foregroundColor(customRdiViewModel.caloriesTextColor)
        }
    }
}

#Preview {
    NavigationStack {
        CustomRdiView()
    }
}
