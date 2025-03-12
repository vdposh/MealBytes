//
//  CustomTextFieldView.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

import SwiftUI

struct CustomTextFieldView: View {
    let title: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray) + Text("*").foregroundColor(.customRed)
            TextField("Enter serving size", text: $text)
                .keyboardType(.decimalPad)
                .padding(.vertical, 5)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray),
                    alignment: .bottom
                )
        }
    }
}
