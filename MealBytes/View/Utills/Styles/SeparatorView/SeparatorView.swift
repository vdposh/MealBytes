//
//  SeparatorView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 11/09/2025.
//

import SwiftUI

struct SeparatorView: View {
    var opacityInset: CGFloat = 0.5
    var topInset: CGFloat = -13
    
    var body: some View {
        Divider()
            .opacity(opacityInset)
            .padding(.trailing, -20)
            .padding(.top, topInset)
    }
}

#Preview {
    PreviewFoodView.foodView
}

#Preview {
    PreviewContentView.contentView
}
