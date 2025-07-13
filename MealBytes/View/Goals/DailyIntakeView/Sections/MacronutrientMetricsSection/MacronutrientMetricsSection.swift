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
        Section {
            VStack(spacing: 15) {
                MacronutrientRow(
                    textFieldBinding: $dailyIntakeViewModel.fat,
                    focusedField: $focusedField,
                    title: "Fat",
                    titleColor: dailyIntakeViewModel.titleColor(
                        for: dailyIntakeViewModel.fat),
                    dailyIntakeViewModel: dailyIntakeViewModel
                )
                .focused($focusedField, equals: .fat)
                
                MacronutrientRow(
                    textFieldBinding: $dailyIntakeViewModel.carbohydrate,
                    focusedField: $focusedField,
                    title: "Carbohydrate",
                    titleColor: dailyIntakeViewModel.titleColor(
                        for: dailyIntakeViewModel.carbohydrate),
                    dailyIntakeViewModel: dailyIntakeViewModel
                )
                .focused($focusedField, equals: .carbohydrate)
                
                MacronutrientRow(
                    textFieldBinding: $dailyIntakeViewModel.protein,
                    focusedField: $focusedField,
                    title: "Protein",
                    titleColor: dailyIntakeViewModel.titleColor(
                        for: dailyIntakeViewModel.protein),
                    dailyIntakeViewModel: dailyIntakeViewModel
                )
                .focused($focusedField, equals: .protein)
            }
            .padding(.bottom, 5)
        } header: {
            Text("Macronutrient Metrics")
        } footer: {
            Text("Enter values for macronutrients. These inputs will be used to precisely calculate daily calorie intake.")
        }
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

