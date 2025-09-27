//
//  SecureFieldView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/03/2025.
//

import SwiftUI

struct SecureFieldView: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    var placeholder: String = "Password"
    
    var body: some View {
        SecureField(placeholder, text: $text)
            .autocapitalization(.none)
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
