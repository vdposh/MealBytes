//
//  Formatter.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
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
    
    func formattedValue(_ value: Double?,
                        unit: Unit,
                        alwaysRoundUp: Bool = false) -> String {
        let safeValue = value ?? 0.0
        let baseValue: Double = alwaysRoundUp ? ceil(safeValue) : safeValue
        
        let scale: Double = pow(10, 2)
        let roundedValue = (baseValue * scale).rounded() / scale
        
        let intValue = Int(roundedValue)
        let firstDecimal = Int(roundedValue * 10) % 10
        let secondDecimal = Int(roundedValue * 100) % 10
        
        let valueString: String
        if secondDecimal == 0 {
            if firstDecimal == 0 {
                valueString = "\(intValue)"
            } else {
                valueString = String(format: "%.1f", roundedValue)
            }
        } else {
            valueString = String(format: "%.2f", roundedValue)
        }
        
        let finalValue = valueString.replacingOccurrences(of: ".", with: ",")
        
        switch unit {
        case .empty:
            return finalValue
        default:
            return "\(finalValue) \(unit.description)"
        }
    }
    
    func roundedValue(_ value: Double, unit: Unit = .empty) -> String {
        let roundedValue = ceil(value)
        switch unit {
        case .empty:
            return String(format: "%.0f", roundedValue)
        default:
            return "\(String(format: "%.0f", roundedValue)) \(unit.description)"
        }
    }
}
