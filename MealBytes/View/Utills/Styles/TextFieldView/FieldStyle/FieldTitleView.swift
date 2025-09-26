//
//  FieldTitleView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/08/2025.
//

import SwiftUI

struct FieldTitleView: View {
    let title: String
    let titleColor: Color
    let isFocused: Binding<Bool>
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.footnote)
                .foregroundStyle(titleColor)
            Text("*")
                .foregroundStyle(.customRed)
        }
        .fontWeight(.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 10)
        .overlay(
            Button(action: {
                isFocused.wrappedValue = true
            }) {
                Color.clear
            }
        )
        .buttonStyle(.borderless)
    }
}

#Preview {
    PreviewFoodView.foodView
}

#Preview {
    PreviewContentView.contentView
}
