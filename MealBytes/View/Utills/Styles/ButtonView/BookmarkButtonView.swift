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
    var size: CGFloat = 24
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isFilled ? "bookmark.fill" : "bookmark")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.accent)
                .frame(width: size, height: size)
        }
        .padding(.horizontal)
        .buttonStyle(.borderless)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewSearchView.searchView
}
