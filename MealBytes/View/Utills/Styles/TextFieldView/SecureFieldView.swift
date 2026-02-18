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
        Label {
            SecureField(placeholder, text: $text)
                .autocapitalization(.none)
        } icon: {
            Image(systemName: "key.fill")
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
