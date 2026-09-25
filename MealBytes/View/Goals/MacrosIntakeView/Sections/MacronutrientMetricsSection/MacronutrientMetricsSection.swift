//
//  MacronutrientMetricsSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct MacronutrientMetricsSection: View {
    @FocusState var focus: MacronutrientsFocus?
    @ObservedObject var macrosIntakeViewModel: MacrosIntakeViewModel
    
    var body: some View {
        Section {
            macrosIntakeCaloriesBody
            macrosIntakeBody
        } footer: {
            Text("Enter macronutrient values. This data will be used to calculate calories.")
        }
    }
    
    private var macrosIntakeCaloriesBody: some View {
        HStack {
            if macrosIntakeViewModel.isValid {
                Label {
                    Text(NutrientType.calories.title)
                } icon: {
                    Image(systemName: "flame.fill")
                        .fontWeight(.semibold)
                        .foregroundStyle(.customCalories)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text(
                macrosIntakeViewModel
                    .text(
                        for: macrosIntakeViewModel.calories,
                        useUnit: false
                    )
            )
        }
    }
    
    @ViewBuilder
    private var macrosIntakeBody: some View {
        MacronutrientFieldView(
            title: NutrientType.fat.title,
            labelIconName: "f.circle.fill",
            labelIconColor: .customFat,
            binding: $macrosIntakeViewModel.fat,
            focus: $focus,
            focusCase: .fat,
            macrosIntakeViewModel: macrosIntakeViewModel
        )
        
        MacronutrientFieldView(
            title: NutrientType.carbohydrate.title,
            labelIconName: "c.circle.fill",
            labelIconColor: .customCarbs,
            binding: $macrosIntakeViewModel.carbohydrate,
            focus: $focus,
            focusCase: .carbohydrate,
            macrosIntakeViewModel: macrosIntakeViewModel
        )
        
        MacronutrientFieldView(
            title: NutrientType.protein.title,
            labelIconName: "p.circle.fill",
            labelIconColor: .customProtein,
            binding: $macrosIntakeViewModel.protein,
            focus: $focus,
            focusCase: .protein,
            macrosIntakeViewModel: macrosIntakeViewModel
        )
    }
}

#Preview {
    PreviewMacrosIntakeView.macrosIntakeView
}
