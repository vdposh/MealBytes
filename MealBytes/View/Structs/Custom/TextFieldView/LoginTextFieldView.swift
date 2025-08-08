//
//  LoginTextFieldView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 15/04/2025.
//

import SwiftUI

struct LoginTextFieldView: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    var title: String = "Email"
    var placeholder: String = "Enter email"
    var titleColor: Color = .primary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            FieldTitleView(
                title: title,
                showStar: true,
                titleColor: titleColor,
                isFocused: Binding(
                    get: { isFocused },
                    set: { isFocused = $0 }
                )
            )
            
            TextField(placeholder, text: $text)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .modifier(FieldStyleModifier(isFocused: $isFocused))
        }
    }
}
