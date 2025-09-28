//
//  MacronutrientRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23/03/2025.
//

import SwiftUI

struct MacronutrientRow: View {
    @Binding var textFieldBinding: String
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
        }
    }
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
