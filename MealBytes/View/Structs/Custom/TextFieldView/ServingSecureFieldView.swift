//
//  ServingSecureFieldView.swift
//  MealBytes
//
//  Created by Porshe on 30/03/2025.
//

import SwiftUI

struct ServingSecureFieldView: View {
    @Binding var text: String
    let title: String
    var placeholder: String = "Enter value"
    var titleColor: Color = .primary
    var textColor: Color = .primary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
                .foregroundColor(titleColor) + Text("*")
                .foregroundColor(.customRed)
            
            SecureField(placeholder, text: $text)
                .frame(height: 35)
                .lineLimit(1)
                .foregroundColor(textColor)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.secondary),
                    alignment: .bottom
                )
        }
    }
}
