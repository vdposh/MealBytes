//
//  LoginTextFieldView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 15/04/2025.
//

import SwiftUI

struct LoginTextFieldView<Focus: Hashable>: View {
    @Binding var text: String
    let focus: FocusState<Focus?>.Binding
    let focusCase: Focus
    var placeholder: String = "Email"
    
    var body: some View {
        contentLoginTextField
            .overlay {
                focusOverlay
            }
    }
    
    private var field: some View {
        TextField(placeholder, text: $text)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .focused(focus, equals: focusCase)
    }
    
    private var contentLoginTextField: some View {
        Label {
            field
        } icon: {
            Image(systemName: "envelope.fill")
                .foregroundStyle(text.isEmpty ? .customGray : .accent)
        }
    }
    
    @ViewBuilder
    private var focusOverlay: some View {
        if focus.wrappedValue != focusCase {
            Button {
                focus.wrappedValue = focusCase
            } label: {
                Color.clear
            }
            .buttonStyle(.borderless)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewLoginView.loginView
}
