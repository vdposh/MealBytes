//
//  MacronutrientMetricsSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct MacronutrientMetricsSection: View {
    @FocusState var focusedField: MacronutrientsFocus?
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        if dailyIntakeViewModel.toggleOn {
            Section {
                MacronutrientFieldView(
                    title: "Fat",
                    binding: $dailyIntakeViewModel.fat,
                    focus: $focusedField,
                    focusCase: .fat,
                    dailyIntakeViewModel: dailyIntakeViewModel
                )
                
                MacronutrientFieldView(
                    title: "Carbohydrate",
                    binding: $dailyIntakeViewModel.carbohydrate,
                    focus: $focusedField,
                    focusCase: .carbohydrate,
                    dailyIntakeViewModel: dailyIntakeViewModel
                )
                
                MacronutrientFieldView(
                    title: "Protein",
                    binding: $dailyIntakeViewModel.protein,
                    focus: $focusedField,
                    focusCase: .protein,
                    dailyIntakeViewModel: dailyIntakeViewModel
                )
            } header: {
                Text("Macronutrients")
                    .foregroundStyle(
                        dailyIntakeViewModel.macronutrientTitleColor()
                    )
            } footer: {
                Text("Enter values for macronutrients. These inputs will be used to precisely calculate daily calorie intake.")
            }
        }
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
