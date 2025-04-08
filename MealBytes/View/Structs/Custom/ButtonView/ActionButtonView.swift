//
//  ActionButtonView.swift
//  MealBytes
//
//  Created by Porshe on 13/03/2025.
//

import SwiftUI

struct ActionButtonView: View {
    let title: String
    let action: () -> Void
    let backgroundColor: Color
    var isEnabled: Bool = true
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(backgroundColor)
                .foregroundColor(.white)
                .font(.headline)
                .lineLimit(1)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}
