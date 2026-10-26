//
//  MacrosIntakeView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 22/03/2025.
//

import SwiftUI

struct MacrosIntakeView: View {
    @FocusState.Binding var focus: MacronutrientsFocus?
    @ObservedObject var macrosIntakeViewModel: MacrosIntakeViewModel
    
    var body: some View {
        Section(
            footer: Text("Enter macronutrients values to calculate calories.")
        ) {
            GoalsNutrientLabelRow(
                type: .calories,
                value: macrosIntakeViewModel.displayCalories,
                unit: macrosIntakeViewModel.energyUnit.unitNutrient
            )
            
            GoalsNutrientFieldRow(
                type: .fat,
                text: $macrosIntakeViewModel.fat,
                focus: $focus,
                focusCase: .fat
            )
            
            GoalsNutrientFieldRow(
                type: .carbohydrate,
                text: $macrosIntakeViewModel.carbohydrate,
                focus: $focus,
                focusCase: .carbohydrate
            )
            
            GoalsNutrientFieldRow(
                type: .protein,
                text: $macrosIntakeViewModel.protein,
                focus: $focus,
                focusCase: .protein
            )
        }
        .onChange(of: focus) {
            handleFocusLoss(focus)
        }
    }
    
    private func handleFocusLoss(_ focus: MacronutrientsFocus?) {
        guard let focus else { return }
        
        macrosIntakeViewModel.handleFocusChange(
            focus: focus,
            didGainFocus: false
        )
    }
}

enum MacronutrientsFocus: Hashable {
    case fat
    case carbohydrate
    case protein
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewGoalsView.goalsView
}
