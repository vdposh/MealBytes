//
//  LoginTextFieldView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 15/04/2025.
//

import SwiftUI

struct LoginTextFieldView: View {
    @Binding var text: String
    @FocusState private var focus: Bool
    var placeholder: String = "Email"
    
    var body: some View {
        TextField("", text: $text)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .frame(height: 35)
            .overlay(alignment: .bottom) {
                Divider()
            }
            .overlay(alignment: .leading) {
                if text.isEmpty {
                    HStack(spacing: 10) {
                        Image(systemName: "person")
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
