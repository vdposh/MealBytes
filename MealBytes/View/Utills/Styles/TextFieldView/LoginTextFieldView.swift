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
        Label {
            TextField(placeholder, text: $text)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        } icon: {
            Image(systemName: "person.fill")
                .foregroundStyle(text.isEmpty ? .customGray : .accent)
                .symbolColorRenderingMode(.gradient)
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
