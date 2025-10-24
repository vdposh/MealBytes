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
            MacronutrientFieldView(
                title: "Fat",
                binding: $dailyIntakeViewModel.fat,
                color: dailyIntakeViewModel
                    .titleColor(for: dailyIntakeViewModel.fat),
                focus: $focusedField,
                focusCase: .fat
            )
            
            MacronutrientFieldView(
                title: "Carbohydrate",
                binding: $dailyIntakeViewModel.carbohydrate,
                color: dailyIntakeViewModel
                    .titleColor(for: dailyIntakeViewModel.carbohydrate),
                focus: $focusedField,
                focusCase: .carbohydrate
            )
            .listSectionSpacing(5)
            
            MacronutrientFieldView(
                title: "Protein",
                binding: $dailyIntakeViewModel.protein,
                color: dailyIntakeViewModel
                    .titleColor(for: dailyIntakeViewModel.protein),
                focus: $focusedField,
                focusCase: .protein,
                showFooter: true
            )
        }
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
