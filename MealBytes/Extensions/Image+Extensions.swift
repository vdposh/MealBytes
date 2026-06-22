//
//  Image+Extensions.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 22.06.2026.
//

import SwiftUI

extension Image {
    func ellipsisMenuStyle() -> some View {
        self
            .foregroundStyle(Color.primary)
            .padding()
            .contentShape(Circle())
    }
}
