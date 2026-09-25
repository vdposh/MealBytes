//
//  DirectionToolbarView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/09/2025.
//

import SwiftUI

struct DirectionToolbarView: View {
    var focused: Bool = false
    var showArrows: Bool = false
    var canMoveUp: Bool = false
    var canMoveDown: Bool = false
    var moveUp: () -> Void = {}
    var moveDown: () -> Void = {}
    var done: () -> Void
    
    var body: some View {
        HStack {
            HStack {
                ToolbarButtonView(
                    icon: "chevron.up",
                    action: moveUp,
                    focused: focused,
                    isActive: canMoveUp,
                    isArrows: true
                )
                
                ToolbarButtonView(
                    icon: "chevron.down",
                    action: moveDown,
                    focused: focused,
                    isActive: canMoveDown,
                    isArrows: true
                )
            }
            .glassEffect(.regular.interactive(), in: .capsule)
            .padding(.horizontal, UIScreen.horizontalPadding(focused: focused))
            .padding(.bottom, focused ? 10 : 26)
            .animation(.default, value: focused)
            
            ToolbarButtonView(
                action: done,
                alignment: .trailing,
                focused: focused
            )
        }
        .opacity(focused ? 1 : 0)
        .allowsHitTesting(focused)
    }
}

#Preview {
    PreviewGoalsView.goalsView
}

#Preview {
    PreviewContentView.contentView
}
