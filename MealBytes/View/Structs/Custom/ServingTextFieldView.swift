//
//  ServingTextFieldView.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

import SwiftUI

struct ServingTextFieldView: View {
    @Binding var text: String
    let title: String
    var placeholder: String = "Enter value"
    var keyboardType: UIKeyboardType = .numberPad

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary) + Text("*")
                .foregroundColor(.customRed)
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .padding(.vertical, 5)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.secondary),
                    alignment: .bottom
                )
        }
    }
}
