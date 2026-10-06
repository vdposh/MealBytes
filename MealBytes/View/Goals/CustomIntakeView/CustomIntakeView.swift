//
//  CustomIntakeView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 12.08.2026.
//

import SwiftUI

struct CustomIntakeView: View {
    @ObservedObject var customIntakeViewModel: CustomIntakeViewModel
    @FocusState.Binding var focus: CustomIntakeFocus?
    
    private let focusOrder: [CustomIntakeFocus] = [
        .calories,
        .fat,
        .carbohydrate,
        .protein
    ]
    
    var body: some View {
        Section {
            NutrientFieldRow(
                type: .calories,
                text: $customIntakeViewModel.calories,
                focus: $focus,
                focusCase: .calories,
                maxIntegerDigits: 5,
                unit: UnitNutrients(
                    rawValue: customIntakeViewModel.energyUnit.rawValue
                )
            )
            
            NutrientFieldRow(
                type: .fat,
                text: $customIntakeViewModel.fat,
                focus: $focus,
                focusCase: .fat
            )
            
            NutrientFieldRow(
                type: .carbohydrate,
                text: $customIntakeViewModel.carbohydrate,
                focus: $focus,
                focusCase: .carbohydrate
            )
            
            NutrientFieldRow(
                type: .protein,
                text: $customIntakeViewModel.protein,
                focus: $focus,
                focusCase: .protein
            )
        } footer: {
            Text("Enter values directly")
        }
        .onChange(of: focus) {
            handleFocusLoss(focus)
        }
    }
    
    private func handleFocusLoss(_ focus: CustomIntakeFocus?) {
        guard let focus else { return }
        
        customIntakeViewModel.handleFocusChange(
            focus: focus,
            didGainFocus: false
        )
    }
}

enum CustomIntakeFocus: Hashable {
    case calories
    case fat
    case carbohydrate
    case protein
}

#Preview {
    PreviewContentView.contentView
}
