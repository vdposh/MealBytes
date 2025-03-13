//
//  BookmarkButtonView.swift
//  MealBytes
//
//  Created by Porshe on 12/03/2025.
//

import SwiftUI

struct BookmarkButtonView: View {
    var action: () -> Void
    var isFilled: Bool
    var systemNameFilled: String = "bookmark.fill"
    var systemNameEmpty: String = "bookmark"
    var width: CGFloat = 52
    var height: CGFloat = 53
    var cornerRadius: CGFloat? = nil
    var lineWidth: CGFloat? = nil
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isFilled ? systemNameFilled : systemNameEmpty)
                .foregroundColor(.customGreen)
                .imageScale(.large)
                .scaleEffect(x: 1.3, y: 1.0)
                .frame(width: width, height: height)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius ?? 0)
                        .stroke(.customGreen, lineWidth: lineWidth ?? 0)
                        .padding(1)
                )
        }
        .buttonStyle(.plain)
    }
}
