//
//  KeyboardToolbarView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/09/2025.
//

import SwiftUI

struct KeyboardToolbarView: View {
    var showArrows: Bool = false
    var canMoveUp: Bool
    var canMoveDown: Bool
    var moveUp: () -> Void
    var moveDown: () -> Void
    var done: () -> Void
    
    var body: some View {
        HStack {
            if showArrows {
                FocusArrowButtonView(
                    direction: .up,
                    isActive: canMoveUp,
                    action: moveUp
                )
                
                FocusArrowButtonView(
                    direction: .down,
                    isActive: canMoveDown,
                    action: moveDown
                )
            }
            
            DoneButtonView(action: done)
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    PreviewRdiView.rdiView
}
