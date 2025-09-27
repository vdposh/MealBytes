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
    var placeholder: String = "Email"
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .frame(height: 35)
            .overlay(alignment: .bottom) {
                Divider()
            }
            .overlay(
                Button(action: {
                    $isFocused.wrappedValue = true
                }) {
                    Color.clear
                }
            )
            .buttonStyle(.borderless)
            .focused($isFocused)
    }
}

#Preview {
    PreviewContentView.contentView
}
