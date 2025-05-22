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
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var isEnabled: Bool = true
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(isFilled ? "bookmarkFill" : "bookmarkEmpty")
                .resizable()
                .scaledToFit()
                .frame(
                    width: width,
                    height: height
                )
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}
