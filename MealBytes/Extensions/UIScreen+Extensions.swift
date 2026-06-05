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
}
