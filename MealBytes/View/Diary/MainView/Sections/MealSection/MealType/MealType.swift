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
        case .breakfast: "sunrise.fill"
        case .lunch: "sun.max.fill"
        case .dinner: "moon.fill"
        case .snacks: "tray.fill"
        }
    }
    
    var color: Color {
        .accentColor.opacity(0.6)
    }
}
