//
//  FocusDirection.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 21/09/2025.
//

import SwiftUI

enum FocusDirection {
    case up, down
}

func moveFocus<T: Equatable>(
    direction: FocusDirection,
    current: T?,
    ordered: [T],
    setter: (T?) -> Void
) {
    guard let current,
          let index = ordered.firstIndex(of: current) else { return }
    
    switch direction {
    case .up:
        if index > 0 {
            setter(ordered[index - 1])
        }
    case .down:
        if index < ordered.count - 1 {
            setter(ordered[index + 1])
        } else {
            setter(nil)
        }
    }
}

func canMoveFocus<T: Equatable>(
    direction: FocusDirection,
    current: T?,
    ordered: [T]
) -> Bool {
    guard let current,
          let index = ordered.firstIndex(of: current) else { return false }
    
    switch direction {
    case .up: return index > 0
    case .down: return index < ordered.count - 1
    }
}

func buildKeyboardToolbar<T: Equatable>(
    current: T?,
    ordered: [T],
    set: @escaping (T?) -> Void,
    normalize: @escaping () -> Void,
    extraDone: (() -> Void)? = nil
) -> KeyboardToolbarView {
    KeyboardToolbarView(
        showArrows: true,
        canMoveUp: canMoveFocus(
            direction: .up,
            current: current,
            ordered: ordered
        ),
        canMoveDown: canMoveFocus(
            direction: .down,
            current: current,
            ordered: ordered
        ),
        moveUp: {
            moveFocus(direction: .up, current: current, ordered: ordered) {
                set($0)
            }
        },
        moveDown: {
            moveFocus(direction: .down, current: current, ordered: ordered) {
                set($0)
            }
        },
        done: {
            set(nil)
            extraDone?()
            normalize()
        }
    )
}
