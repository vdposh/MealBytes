//
//  FieldTitleView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/08/2025.
//

import SwiftUI

struct FieldTitleView: View {
    let title: String
    let showStar: Bool
    let titleColor: Color
    let isFocused: Binding<Bool>
    
    var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.caption)
                .foregroundStyle(titleColor)
            if showStar {
                Text("*")
                    .foregroundStyle(.customRed)
            }
        }
        .frame(height: 15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
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
