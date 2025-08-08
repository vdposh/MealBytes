//
//  SecureFieldView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/03/2025.
//

import SwiftUI

struct SecureFieldView: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    let title: String
    var placeholder: String = "Enter value"
    var titleColor: Color = .primary
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            FieldTitleView(
                title: title,
                showStar: true,
                titleColor: titleColor,
                isFocused: Binding(
                    get: { isFocused },
                    set: { isFocused = $0 }
                )
            )
            
            SecureField(placeholder, text: $text)
                .autocapitalization(.none)
                .modifier(FieldStyleModifier(isFocused: $isFocused))
        }
    }
}
