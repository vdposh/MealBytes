//
//  InvisibleButtonStyle.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/10/2025.
//

import SwiftUI

struct ButtonStyleInvisible: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(1)
    }
}
