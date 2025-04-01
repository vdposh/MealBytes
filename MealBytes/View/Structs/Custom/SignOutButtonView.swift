//
//  SignOutButtonView.swift
//  MealBytes
//
//  Created by Porshe on 31/03/2025.
//

import SwiftUI

struct SignOutButtonView: View {
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
                .frame(width: 150)
                .lineLimit(1)
                .background(backgroundColor)
                .cornerRadius(12)
        }
    }
}
