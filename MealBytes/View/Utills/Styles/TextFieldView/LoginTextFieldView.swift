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
            .focused($focus)
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
        if !focus {
            Button {
                focus = true
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
