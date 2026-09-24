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
        } footer: {
            Text("Enter macronutrient values in grams. This data will be used to calculate calories and track your goals.")
        }
    }
}

#Preview {
    PreviewMacrosIntakeView.macrosIntakeView
}
