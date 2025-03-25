//
//  CalorieMetricsSection.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI

struct CalorieMetricsSection: View {
    var isCaloriesFocused: FocusState<Bool>.Binding
    @ObservedObject var customRdiViewModel: CustomRdiViewModel
    
    var body: some View {
        Section {
            VStack {
                sectionTitle
                calorieInputRow
            }
            .padding(.bottom, 5)
        }
    }
    
    private var sectionTitle: some View {
        Text("Required Calorie Metrics")
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 5)
    }
    
    private var calorieInputRow: some View {
        HStack(alignment: .bottom) {
            ServingTextFieldView(
                text: $customRdiViewModel.calories,
                title: "Calories",
                titleColor: customRdiViewModel.titleColor(
                    for: customRdiViewModel.calories),
                textColor: customRdiViewModel.caloriesTextColor
            )
            .focused(isCaloriesFocused)
            .disabled(customRdiViewModel.isCaloriesTextFieldActive)
            .padding(.trailing, 5)
            
            Text("kcal")
                .font(.callout)
                .foregroundColor(customRdiViewModel.caloriesTextColor)
        }
        .padding(.top, 5)
    }

}
