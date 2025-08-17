//
//  FieldStyleModifier.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/08/2025.
//


import SwiftUI

struct FieldStyleModifier: ViewModifier {
    let isFocused: FocusState<Bool>.Binding
    
    func body(content: Content) -> some View {
        content
            .frame(height: 35)
            .lineLimit(1)
            .focused(isFocused)
            .overlay(
                FieldUnderlineView(isFocused: isFocused.wrappedValue),
                alignment: .bottom
            )
    }
}
