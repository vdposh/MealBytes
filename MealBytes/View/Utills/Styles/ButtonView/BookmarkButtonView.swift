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
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .fill(
                        isFilled ? Color.accent : Color.secondary
                            .opacity(0.2))
                    .frame(width: 53, height: 53)
                
                Image(systemName: isFilled ? "bookmark.slash" : "bookmark")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(isFilled ? .regular : .medium)
                    .frame(width: 25, height: 25)
                    .foregroundStyle(isFilled ? .white : .accent)
                    .symbolColorRenderingMode(.gradient)
            }
        }
        .glassEffect(.regular.interactive())
        .padding(.leading, 8)
        .buttonStyle(ButtonStyleInvisible())
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewFoodView.foodView
}
