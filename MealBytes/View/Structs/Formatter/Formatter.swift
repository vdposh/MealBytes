//
//  Formatter.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct Formatter {
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
    
    func formattedValue(_ value: Double,
                        unit: Unit,
                        alwaysRoundUp: Bool = false) -> String {
        let roundedValue: Double
        
        switch alwaysRoundUp {
        case true:
            roundedValue = ceil(value)
        case false:
            roundedValue = round(value * 10) / 10
        }
        
        var finalValue: String
        
        switch roundedValue.truncatingRemainder(dividingBy: 1) {
        case 0:
            finalValue = String(format: "%.0f", roundedValue)
        default:
            finalValue = String(format: "%.1f", roundedValue)
        }
        
        finalValue = finalValue.replacingOccurrences(of: ".", with: ",")
        
        switch unit {
        case .empty:
            return finalValue
        default:
            return "\(finalValue) \(unit.description)"
        }
    }
}
