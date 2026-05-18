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
                .customGreenSwipe.opacity(0.6),
                .customGreenSwipe.opacity(0.8),
                .customGreenSwipe,
                .accent
            ]
        )
    }
}

extension Gradient {
    static var progressGradientGreen: Gradient {
        Gradient(
            colors: [
                .accent,
                .customGreenSwipe,
                .customGreenSwipe.opacity(0.8),
                .customGreenSwipe.opacity(0.6),
            ]
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
