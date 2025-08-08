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
    let title: String
    var placeholder: String = "Enter value"
    var titleColor: Color = .primary
    var textColor: Color = .primary
    
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
            
            SecureField(placeholder, text: $text)
                .frame(height: 35)
                .lineLimit(1)
                .foregroundColor(textColor)
                .focused($isFocused)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .opacity(isFocused ? 1 : 0.4)
                        .foregroundColor(
                            isFocused ? .customGreen : .secondary
                        ),
                    alignment: .bottom
                )
        }
    }
}
