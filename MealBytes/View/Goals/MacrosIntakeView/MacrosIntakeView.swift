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
            Text("Enter macronutrients values to calculate calories.")
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
