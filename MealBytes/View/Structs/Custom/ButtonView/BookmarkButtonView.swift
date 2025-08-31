//
//  BookmarkButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 12/03/2025.
//

import SwiftUI

struct BookmarkButtonView: View {
    var action: () -> Void
    var color: Color = .accentColor
    var isFilled: Bool
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: isFilled ? "bookmark.fill" : "bookmark")
                .resizable()
                .scaledToFit()
                .frame(
                    width: width,
                    height: height
                )
        }
        .buttonStyle(.plain)
        .foregroundStyle(color)
    }
}
