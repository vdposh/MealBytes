//
//  MacronutrientFieldView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/10/2025.
//

import SwiftUI

struct MacronutrientFieldView: View {
    let title: String
    let binding: Binding<String>
    let focus: FocusState<MacronutrientsFocus?>.Binding
    let focusCase: MacronutrientsFocus
    
    var body: some View {
        ServingTextFieldView(
            text: binding,
            stackText: title,
            trailingUnit: "grams",
            alwaysShowUnit: true,
            useStack: true,
            keyboardType: .numberPad,
            inputMode: .integer,
            maxIntegerDigits: 3
        )
        .focused(focus, equals: focusCase)
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
