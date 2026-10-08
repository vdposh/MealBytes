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
                .focused($focus)
        } icon: {
            Button {
                focus = true
            } label: {
                Image(systemName: "envelope.fill")
                    .foregroundStyle(text.isEmpty ? .customGray : .accent)
            }
            .buttonStyle(InvisibleButtonStyle())
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewLoginView.loginView
}
