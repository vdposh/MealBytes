//
//  MacronutrientRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct MacronutrientRow: View {
    @Binding var textFieldBinding: String
    var focusedField: FocusState<MacronutrientsFocus?>.Binding
    let title: String
    let placeholder: String
    let titleColor: Color
    @ObservedObject var dailyIntakeViewModel: DailyIntakeViewModel
    
    var body: some View {
        HStack {
            ServingTextFieldView(
                text: $textFieldBinding,
                placeholder: placeholder,
                keyboardType: .numberPad,
                inputMode: .integer,
                maxIntegerDigits: 3
            )
            .focused(focusedField, equals: focusValue)
        }
    }
    
    private var focusValue: MacronutrientsFocus {
        switch title {
        case "Fat": return .fat
        case "Carbohydrate": return .carbohydrate
        case "Protein": return .protein
        default: return .fat
        }
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
