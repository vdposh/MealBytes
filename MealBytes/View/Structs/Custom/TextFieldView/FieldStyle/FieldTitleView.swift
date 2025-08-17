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
        Button {
            isFocused.wrappedValue = true
        } label: {
            HStack(spacing: 0) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(titleColor)
                if showStar {
                    Text("*")
                        .foregroundColor(.customRed)
                }
            }
            .frame(height: 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
