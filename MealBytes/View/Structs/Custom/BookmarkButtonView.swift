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
    var imageFilled: String = "bookmarkFill"
    var imageEmpty: String = "bookmarkEmpty"
    var width: CGFloat? = nil
    var height: CGFloat? = nil
    var isEnabled: Bool = true
    
    var body: some View {
        Button(action: action) {
            Image(isFilled ? imageFilled : imageEmpty)
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
