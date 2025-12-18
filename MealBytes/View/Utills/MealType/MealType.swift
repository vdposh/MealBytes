//
//  MealType.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 17/03/2025.
//

import SwiftUI

enum MealType: String, Codable, CaseIterable, Identifiable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snacks = "Snacks"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .breakfast: "sun.horizon.fill"
        case .lunch: "sun.max.fill"
        case .dinner: "sun.haze.fill"
        case .snacks: "moon.stars.fill"
        }
    }
    
    var renderingMode: SymbolRenderingMode {
        switch rendering {
        case .multicolor: .multicolor
        case .palette: .palette
        }
    }
    
    var foregroundStyle: (Color, Color) {
        switch rendering {
        case .multicolor: (.primary, .primary)
        case .palette(let a, let b): (a, b)
        }
    }
    
    var rendering: Rendering {
        switch self {
        case .snacks: .palette(.customMoon, .customStar)
        default: .multicolor
        }
    }
    
    enum Rendering {
        case multicolor
        case palette(Color, Color)
    }
}

#Preview {
    PreviewContentView.contentView
}
