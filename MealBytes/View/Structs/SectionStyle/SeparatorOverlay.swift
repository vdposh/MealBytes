//
//  SeparatorOverlay.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 11/09/2025.
//

import SwiftUI

struct SeparatorOverlay: View {
    var topInset: CGFloat = -13
    
    var body: some View {
        Divider()
            .opacity(0.6)
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
