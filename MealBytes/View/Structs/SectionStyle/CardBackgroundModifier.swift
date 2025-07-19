//
//  CardBackgroundModifier.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/07/2025.
//

import SwiftUI

struct CardBackgroundModifier: ViewModifier {
    let useBackground: Bool
    
    func body(content: Content) -> some View {
        Group {
            if useBackground {
                content
                    .background(
                        Color(uiColor: .secondarySystemGroupedBackground)
                    )
            } else {
                content
            }
        }
        .cornerRadius(14)
        .padding(.horizontal, 20)
    }
}
