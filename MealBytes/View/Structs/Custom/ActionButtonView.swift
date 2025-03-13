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
    let isEnabled: Bool
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isEnabled ? backgroundColor :
                                backgroundColor.opacity(0.5))
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}
