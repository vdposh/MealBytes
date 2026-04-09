//
//  KeyboardToolbarView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/09/2025.
//

import SwiftUI

struct KeyboardToolbarView: View {
    var showArrows: Bool = false
    var canMoveUp: Bool = false
    var canMoveDown: Bool = false
    var moveUp: () -> Void = {}
    var moveDown: () -> Void = {}
    var done: () -> Void
    
    var body: some View {
        HStack(spacing: 30) {
            if showArrows {
                ToolbarIconButton(
                    systemImage: "chevron.up",
                    isActive: canMoveUp,
                    action: moveUp
                )
                
                ToolbarIconButton(
                    systemImage: "chevron.down",
                    isActive: canMoveDown,
                    action: moveDown
                )
            }
            
            ToolbarIconButton(
                systemImage: "checkmark",
                isActive: true,
                action: done
            )
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal)
        .glassEffect(.regular.interactive())
        .padding(.horizontal)
        .padding(.bottom, 10)
        .contentShape(Rectangle())
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewDailyIntakeView.dailyIntakeView
}
