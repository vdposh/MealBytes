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
        contentSecureField
            .overlay {
                focusOverlay
            }
    }
    
    private var field: some View {
        SecureField(placeholder, text: $text)
            .autocapitalization(.none)
            .focused($focus)
    }
    
    private var contentSecureField: some View {
        Label {
            field
        } icon: {
            Image(systemName: "key.fill")
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
