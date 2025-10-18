//
//  Formatter.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct Formatter {
    func formattedValue(
        _ value: Double?,
        unit: Unit,
        alwaysRoundUp: Bool = false
    ) -> String {
        let safeValue = value ?? 0.0
        let baseValue = alwaysRoundUp ? ceil(safeValue) : safeValue
        
        let rounded = (baseValue * 100).rounded() / 100
        
        let raw = String(format: "%.2f", rounded)
        
        let cleaned: String
        if raw.hasSuffix("00") {
            cleaned = "\(Int(rounded))"
        } else if raw.hasSuffix("0") {
            cleaned = String(raw.dropLast())
        } else {
            cleaned = raw
        }
        
        let finalValue = cleaned.preparedForLocaleDecimal
        
        switch unit {
        case .empty: return finalValue
        default: return "\(finalValue) \(unit.description)"
        }
    }
    
    func roundedValue(_ value: Double, unit: Unit = .empty) -> String {
        let roundedValue = ceil(value)
        switch unit {
        case .empty: return String(format: "%.0f", roundedValue)
        default:
            return "\(String(format: "%.0f", roundedValue)) \(unit.description)"
        }
    }
    
    enum Unit: String {
        case empty
        case kcal
        case g
        case mg
        
        var description: String {
            switch self {
            case .empty: ""
            case .kcal: "kcal"
            case .g: "g"
            case .mg: "mg"
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
