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
    var showLabel: Bool = true
    
    var body: some View {
        content
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
    
    @ViewBuilder
    private var content: some View {
        if showLabel {
            Label {
                TextField(placeholder, text: $text)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } icon: {
                Image(systemName: "envelope.fill")
                    .foregroundStyle(text.isEmpty ? .customGray : .accent)
                    .symbolColorRenderingMode(.gradient)
            }
        } else {
            TextField(placeholder, text: $text)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewLoginView.loginView
}
