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
    let value: String
    let unitRight: String
    let unitLeft: String
    let title: String
    let titleColor: Color
    
    var body: some View {
        HStack(alignment: .bottom) {
            ServingTextFieldView(
                text: $textFieldBinding,
                title: title,
                titleColor: titleColor
            )
            .focused($focusedField)
            .padding(.trailing, 5)
            
            Text(unitLeft)
                .font(.callout)
                .frame(width: 15, alignment: .leading)
            
            HStack (spacing: 5) {
                Text(value)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                Text(unitRight)
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .frame(width: 15, alignment: .leading)
            }
            .frame(width: 90, alignment: .trailing)
        }
    }
}
