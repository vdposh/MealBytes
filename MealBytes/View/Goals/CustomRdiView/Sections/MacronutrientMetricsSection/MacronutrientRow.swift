//
//  MacronutrientRow.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI

struct MacronutrientRow: View {
    @Binding var textFieldBinding: String
    @FocusState var focusedField: Bool
    let title: String
    let titleColor: Color
    @ObservedObject var customRdiViewModel: CustomRdiViewModel
    
    var body: some View {
        HStack(alignment: .bottom) {
            ServingTextFieldView(
                text: $textFieldBinding,
                title: title,
                keyboardType: .decimalPad,
                titleColor: titleColor
            )
            .focused($focusedField)
            .padding(.trailing, 5)
            
            Text("g")
        }
    }
}

#Preview {
    NavigationStack {
        CustomRdiView()
    }
}
