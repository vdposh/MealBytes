//
//  MacronutrientFieldView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/10/2025.
//

import SwiftUI

struct MacronutrientFieldView: View {
    let title: String
    let labelIconName: String
    let labelIconColor: Color
    let binding: Binding<String>
    let focus: FocusState<MacronutrientsFocus?>.Binding
    let focusCase: MacronutrientsFocus
    
    @ObservedObject var macrosIntakeViewModel: MacrosIntakeViewModel
    
    var body: some View {
        ServingTextFieldView(
            text: binding,
            labelIconName: labelIconName,
            labelIconColor: labelIconColor,
            stackText: title,
            useStackTrailing: true,
            keyboardType: .numberPad,
            inputMode: .integer,
            maxIntegerDigits: 3
        )
        .focused(focus, equals: focusCase)
    }
}

#Preview {
    PreviewMacrosIntakeView.macrosIntakeView
}
