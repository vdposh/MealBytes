//
//  UIScreen+Extensions.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 02.06.2026.
//

import SwiftUI

extension UIScreen {
    static var currentSize: CGSize {
        (
            UIApplication.shared.connectedScenes.first as? UIWindowScene
        )?.screen.bounds.size ?? .zero
    }
    
    static func horizontalPadding(focused: Bool) -> CGFloat {
        let width = currentSize.width
        let base: CGFloat = width < 420 ? 16 : (focused ? 20 : 16)
        return focused ? base : base * 1.75
    }
}
