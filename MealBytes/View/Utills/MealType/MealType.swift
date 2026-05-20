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
        case .snacks: "clock.badge"
        }
    }
    
    var symbolRendering: SymbolRenderingMode {
        self == .snacks ? .palette : .multicolor
    }
    
    var colors: (primary: Color, secondary: Color) {
        if self == .snacks {
            return (.customYellow, .customFat)
        } else {
            return (.primary, .primary)
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
