//
//  MealType.swift
//  MealBytes
//
//  Created by Porshe on 17/03/2025.
//

import SwiftUI

enum MealType: String, CaseIterable, Identifiable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case other = "Other"
    
    var id: String { rawValue }
    
    var iconName: String {
        switch self {
        case .breakfast: "sunrise.fill"
        case .lunch: "sun.max.fill"
        case .dinner: "moon.fill"
        case .other: "tray.fill"
        }
    }
    
    var color: Color {
        .customGreen.opacity(0.6)
    }
}
