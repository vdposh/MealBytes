//
//  Gradient+Extensions.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13.05.2026.
//

import SwiftUI

extension Gradient {
    static var progressGradientOrange: Gradient {
        Gradient(
            colors: [
                .customOrange,
                .customOrangeSwipe,
                .customStar,
                .accent,
                .customGreenSwipe
            ]
        )
    }
}

extension Gradient {
    static var progressGradientGreen: Gradient {
        Gradient(
            colors: [
                .customGreenSwipe,
                .accent,
                .customStar,
                .customOrangeSwipe,
                .customOrange
            ]
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
