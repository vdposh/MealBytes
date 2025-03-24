//
//  RdiButtonView.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

struct RdiButtonView: View {
    let title: String
    let backgroundColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(backgroundColor)
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }
}
