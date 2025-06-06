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
    let titleColor: Color
    @ObservedObject var customRdiViewModel: CustomRdiViewModel
    
    var body: some View {
        HStack(alignment: .bottom) {
            ServingTextFieldView(
                text: $textFieldBinding,
                title: title,
                keyboardType: .decimalPad,
                titleColor: titleColor,
                maxIntegerDigits: 3
            )
            .focused(focusedField, equals: focusValue)
            .padding(.trailing, 5)
            
            Text("g")
        }
    }
    
    private var focusValue: MacronutrientsFocus {
        switch title {
        case "Fat":
            return .fat
        case "Carbohydrate":
            return .carbohydrate
        case "Protein":
            return .protein
        default:
            return .fat
        }
    }
}

#Preview {
    NavigationStack {
        CustomRdiView()
    }
}
