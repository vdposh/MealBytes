//
//  InvisibleButtonStyle.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 06/04/2025.
//

import SwiftUI

struct InvisibleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 1.0 : 1.0)
    }
}
