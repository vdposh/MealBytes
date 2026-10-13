//
//  SecureFieldView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/03/2025.
//

import SwiftUI

struct SecureFieldView<Focus: Hashable>: View {
    @Binding var text: String
    let focus: FocusState<Focus?>.Binding
    let focusCase: Focus
    var placeholder: String = "Password"
    var textContentType: UITextContentType? = .password
    var submitLabel: SubmitLabel = .done
    var onSubmit: (() -> Void)? = nil
    
    var body: some View {
        contentSecureField
            .overlay {
                focusOverlay
            }
    }
    
    private var field: some View {
        SecureField(placeholder, text: $text)
            .textContentType(textContentType)
            .autocapitalization(.none)
            .focused(focus, equals: focusCase)
            .submitLabel(submitLabel)
            .onSubmit {
                onSubmit?()
            }
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
