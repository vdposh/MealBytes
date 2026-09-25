//
//  MacrosMetricsSection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct MacrosMetricsSection: View {
    @FocusState var focus: MacronutrientsFocus?
    @ObservedObject var macrosIntakeViewModel: MacrosIntakeViewModel
    
    var body: some View {
        Section {
            NutrientLabelRow(
                type: .calories,
                value: macrosIntakeViewModel.calories
            )
            
            NutrientFieldRow(
                type: .fat,
                text: $macrosIntakeViewModel.fat,
                focus: $focus,
                focusCase: .fat
            )
            
            NutrientFieldRow(
                type: .carbohydrate,
                text: $macrosIntakeViewModel.carbohydrate,
                focus: $focus,
                focusCase: .carbohydrate
            )
            
            NutrientFieldRow(
                type: .protein,
                text: $macrosIntakeViewModel.protein,
                focus: $focus,
                focusCase: .protein
            )
        } footer: {
            Text("Enter macronutrient values. This data will be used to calculate calories.")
        }
    }
}

#Preview {
    PreviewMacrosIntakeView.macrosIntakeView
}
