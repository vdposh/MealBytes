//
//  FocusArrowButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/09/2025.
//

import SwiftUI

struct FocusArrowButtonView: View {
    enum Direction {
        case up, down
        
        var systemImage: String {
            switch self {
            case .up: return "chevron.up"
            case .down: return "chevron.down"
            }
        }
    }
    
    let direction: Direction
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: direction.systemImage)
        }
        .padding(.trailing)
        .disabled(!isActive)
    }
}
