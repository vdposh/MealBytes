//
//  LoginTextFieldView.swift
//  MealBytes
//
//  Created by Porshe on 15/04/2025.
//

import SwiftUI

struct LoginTextFieldView: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    var title: String = "Email"
    var placeholder: String = "Enter your email"
    var keyboardType: UIKeyboardType = .emailAddress
    var titleColor: Color = .primary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
                .foregroundColor(titleColor) + Text("*")
                .foregroundColor(.customRed)
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .frame(height: 35)
                .lineLimit(1)
                .focused($isFocused)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(isFocused ? .customGreen : .secondary)
                        .animation(.easeInOut, value: isFocused),
                    alignment: .bottom
                )
        }
    }
}
