//
//  BookmarkButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 12/03/2025.
//

import SwiftUI

struct BookmarkButtonView: View {
    var action: () -> Void
    var isFilled: Bool
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isFilled ? "bookmark.fill" : "bookmark")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.accent)
                .frame(width: 30, height: 30)
        }
        .padding(.horizontal, 22)
        .buttonStyle(.borderless)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
