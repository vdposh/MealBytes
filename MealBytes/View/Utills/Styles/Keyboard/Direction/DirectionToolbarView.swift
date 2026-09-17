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
    
    private var horizontalPadding: CGFloat {
        let width = UIScreen.currentSize.width
        let base: CGFloat = width < 420 ? 16 : (focused ? 20 : 16)
        return focused ? base : base * 1.75
    }
    
    var body: some View {
        HStack {
            HStack {
                DirectionIconButton(
                    systemImage: "chevron.up",
                    isActive: canMoveUp,
                    action: moveUp
                )
                
                DirectionIconButton(
                    systemImage: "chevron.down",
                    isActive: canMoveDown,
                    action: moveDown
                )
            }
            .transaction { $0.animation = nil }
            .glassEffect(.regular.interactive(), in: .capsule)
            .opacity(showArrows ? 1 : 0)
            
            DirectionIconButton(
                systemImage: "checkmark",
                isActive: true,
                action: done
            )
            .glassEffect(.regular.interactive(), in: .circle)
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.bottom, focused ? 10 : 26)
        .animation(.default, value: focused)
        .opacity(focused ? 1 : 0)
        .allowsHitTesting(focused)
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
