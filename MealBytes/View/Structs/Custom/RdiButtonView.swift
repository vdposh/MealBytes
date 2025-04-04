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
    
    var body: some View {
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
