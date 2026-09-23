//
//  MacronutrientMetricsSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct MacronutrientMetricsSection: View {
    @FocusState var focus: MacronutrientsFocus?
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        Section {
            MacronutrientFieldView(
                title: NutrientType.fat.title,
                binding: $dailyIntakeViewModel.fat,
                focus: $focus,
                focusCase: .fat,
                dailyIntakeViewModel: dailyIntakeViewModel
            )
            
            MacronutrientFieldView(
                title: NutrientType.carbohydrate.title,
                binding: $dailyIntakeViewModel.carbohydrate,
                focus: $focus,
                focusCase: .carbohydrate,
                dailyIntakeViewModel: dailyIntakeViewModel
            )
            
            MacronutrientFieldView(
                title: NutrientType.protein.title,
                binding: $dailyIntakeViewModel.protein,
                focus: $focus,
                focusCase: .protein,
                dailyIntakeViewModel: dailyIntakeViewModel
            )
        } footer: {
            Text("Enter macronutrient values in grams. This data will be used to calculate calories and track your goals.")
        }
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
