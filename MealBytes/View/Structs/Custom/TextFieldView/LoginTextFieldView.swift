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
    var placeholder: String = "Enter email"
    var keyboardType: UIKeyboardType = .emailAddress
    var titleColor: Color = .primary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                isFocused = true
            }) {
                HStack(spacing: 0) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(titleColor)
                    Text("*")
                        .foregroundColor(.customRed)
                }
                .frame(height: 15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
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
                        .foregroundColor(isFocused ? .customGreen : .secondary),
                    alignment: .bottom
                )
        }
    }
}
