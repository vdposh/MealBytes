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
                .frame(width: 35, height: 35)
        }
        .padding(.horizontal)
        .buttonStyle(.borderless)
    }
}

#Preview {
    PreviewFoodView.foodView
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewSearchView.searchView
}
