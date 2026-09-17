////
////  DirectionToolbarView.swift
////  MealBytes
////
////  Created by Vlad Posherstnik on 19/09/2025.
////
//
//import SwiftUI
//
//struct DirectionToolbarView: View {
//    var showArrows: Bool = false
//    var canMoveUp: Bool = false
//    var canMoveDown: Bool = false
//    var moveUp: () -> Void = {}
//    var moveDown: () -> Void = {}
//    var done: () -> Void
//    
//    var body: some View {
//        HStack(spacing: 30) {
//            if showArrows {
//                DirectionIconButton(
//                    systemImage: "chevron.up",
//                    isActive: canMoveUp,
//                    action: moveUp
//                )
//                .transaction { $0.animation = nil }
//                
//                DirectionIconButton(
//                    systemImage: "chevron.down",
//                    isActive: canMoveDown,
//                    action: moveDown
//                )
//                .transaction { $0.animation = nil }
//            }
//            
//            DirectionIconButton(
//                systemImage: "checkmark",
//                isActive: true,
//                action: done
//            )
//            .frame(maxWidth: .infinity, alignment: .trailing)
//        }
//        .padding(.horizontal)
//        .glassEffect(.regular.interactive())
//        .containerRelativeFrame(.horizontal) { width, _ in
//            width * (width < 420 ? 0.92 : 0.91)
//        }
//        .padding(.bottom, 10)
//        .contentShape(Rectangle())
//    }
//}
//
//#Preview {
//    PreviewContentView.contentView
//}
//
//#Preview {
//    PreviewDailyIntakeView.dailyIntakeView
//}

//
//  DirectionToolbarView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/09/2025.
//

import SwiftUI

struct DirectionToolbarView: View {
    var showArrows: Bool = false
    var canMoveUp: Bool = false
    var canMoveDown: Bool = false
    var moveUp: () -> Void = {}
    var moveDown: () -> Void = {}
    var done: () -> Void
    
    private var horizontalPadding: CGFloat {
        let width = UIScreen.currentSize.width
        return width < 420 ? 16 : 20
    }
    
    var body: some View {
        HStack(spacing: 30) {
            if showArrows {
                DirectionIconButton(
                    systemImage: "chevron.up",
                    isActive: canMoveUp,
                    action: moveUp
                )
                .transaction { $0.animation = nil }
                
                DirectionIconButton(
                    systemImage: "chevron.down",
                    isActive: canMoveDown,
                    action: moveDown
                )
                .transaction { $0.animation = nil }
            }
            
            DirectionIconButton(
                systemImage: "checkmark",
                isActive: true,
                action: done
            )
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal)
        .glassEffect(.regular.interactive())
        .padding(.horizontal, horizontalPadding)
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
