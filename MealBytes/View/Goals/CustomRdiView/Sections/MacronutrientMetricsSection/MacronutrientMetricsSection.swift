//
//  MacronutrientMetricsSection.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI

struct MacronutrientMetricsSection: View {
    @FocusState var focusedField: Bool
    @ObservedObject var customRdiViewModel: CustomRdiViewModel
    
    var body: some View {
        Section {
            VStack {
                VStack(spacing: 15) {
                    MacronutrientRow(
                        textFieldBinding: $customRdiViewModel.fat,
                        focusedField: _focusedField,
                        title: "Fat",
                        titleColor: customRdiViewModel.titleColor(
                            for: customRdiViewModel.fat),
                        customRdiViewModel: customRdiViewModel
                    )
                    
                    MacronutrientRow(
                        textFieldBinding: $customRdiViewModel.carbohydrate,
                        focusedField: _focusedField,
                        title: "Carbohydrate",
                        titleColor: customRdiViewModel.titleColor(
                            for: customRdiViewModel.carbohydrate),
                        customRdiViewModel: customRdiViewModel
                    )
                    
                    MacronutrientRow(
                        textFieldBinding: $customRdiViewModel.protein,
                        focusedField: _focusedField,
                        title: "Protein",
                        titleColor: customRdiViewModel.titleColor(
                            for: customRdiViewModel.protein),
                        customRdiViewModel: customRdiViewModel
                    )
                }
                .padding(.bottom, 5)
            }
        } header: {
            Text("Macronutrient Metrics")
        } footer: {
            Text("Enter values for macronutrients. These inputs will be used to calculate your daily calorie intake precisely.")
        }
    }
}

#Preview {
    NavigationStack {
        CustomRdiView()
    }
}
