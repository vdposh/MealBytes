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
                MacronutrientRow(
                    textFieldBinding: $dailyIntakeViewModel.fat,
                    focusedField: $focusedField,
                    title: "Fat",
                    placeholder: "Fat value",
                    titleColor: dailyIntakeViewModel.titleColor(
                        for: dailyIntakeViewModel.fat
                    ),
                    dailyIntakeViewModel: dailyIntakeViewModel
                )
                .focused($focusedField, equals: .fat)
            } header: {
                Text("Fat")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        dailyIntakeViewModel.titleColor(
                            for: dailyIntakeViewModel.fat
                        )
                    )
            }
            
            Section {
                MacronutrientRow(
                    textFieldBinding: $dailyIntakeViewModel.carbohydrate,
                    focusedField: $focusedField,
                    title: "Carbohydrate",
                    placeholder: "Carbohydrate value",
                    titleColor: dailyIntakeViewModel.titleColor(
                        for: dailyIntakeViewModel.carbohydrate
                    ),
                    dailyIntakeViewModel: dailyIntakeViewModel
                )
                .focused($focusedField, equals: .carbohydrate)
            } header: {
                Text("Carbohydrate")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        dailyIntakeViewModel.titleColor(
                            for: dailyIntakeViewModel.carbohydrate
                        )
                    )
            }
            .listSectionSpacing(5)
            
            Section {
                MacronutrientRow(
                    textFieldBinding: $dailyIntakeViewModel.protein,
                    focusedField: $focusedField,
                    title: "Protein",
                    placeholder: "Protein value",
                    titleColor: dailyIntakeViewModel.titleColor(
                        for: dailyIntakeViewModel.protein
                    ),
                    dailyIntakeViewModel: dailyIntakeViewModel
                )
                .focused($focusedField, equals: .protein)
            } header: {
                Text("Protein")
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(
                        dailyIntakeViewModel.titleColor(
                            for: dailyIntakeViewModel.protein
                        )
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
