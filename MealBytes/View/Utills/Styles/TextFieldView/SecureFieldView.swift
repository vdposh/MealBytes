//
//  SecureFieldView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/03/2025.
//

import SwiftUI

struct SecureFieldView: View {
    @Binding var text: String
    @FocusState private var focus: Bool
    var placeholder: String = "Password"
    
    var body: some View {
        SecureField("", text: $text)
            .autocapitalization(.none)
            .frame(height: 35)
            .overlay(alignment: .bottom) {
                Divider()
            }
            .overlay(alignment: .leading) {
                if text.isEmpty {
                    HStack(spacing: 10) {
                        Image(systemName: "key")
                            .frame(width: 15)
                        Text(placeholder)
                    }
                    .foregroundStyle(.tertiary)
                }
            }
            .overlay(
                Button {
                    $focus.wrappedValue = true
                } label: {
                    Color.clear
                }
            )
            .buttonStyle(.borderless)
            .focused($focus)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewLoginView.loginView
}
