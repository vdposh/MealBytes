//
//  FieldUnderlineView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/08/2025.
//


import SwiftUI

struct FieldUnderlineView: View {
    let isFocused: Bool
    
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .scaleEffect(x: 1, y: isFocused ? 1.1 : 1, anchor: .center)
            .opacity(isFocused ? 1 : 0.4)
            .foregroundColor(isFocused ? .customGreen : .secondary)
    }
}
