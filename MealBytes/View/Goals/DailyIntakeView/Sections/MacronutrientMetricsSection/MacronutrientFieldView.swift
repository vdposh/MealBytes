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
    let color: Color
    let focus: FocusState<MacronutrientsFocus?>.Binding
    let focusCase: MacronutrientsFocus
    var showFooter: Bool = false
    
    var body: some View {
        Section {
            ServingTextFieldView(
                text: binding,
                placeholder: "\(title) value",
                trailingUnit: "grams",
                alwaysShowUnit: true,
                keyboardType: .numberPad,
                inputMode: .integer,
                maxIntegerDigits: 3
            )
            .focused(focus, equals: focusCase)
        } header: {
            Text(title)
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(color)
        } footer: {
            if showFooter {
                Text("Enter values for macronutrients. These inputs will be used to precisely calculate daily calorie intake.")
            }
        }
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
