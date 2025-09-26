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
    var placeholder: String = "Enter Email"
    var titleColor: Color = .primary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            FieldTitleView(
                title: title,
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
                .frame(height: 30)
                .overlay(alignment: .bottom) {
                    Divider()
                }
                .focused($isFocused)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
