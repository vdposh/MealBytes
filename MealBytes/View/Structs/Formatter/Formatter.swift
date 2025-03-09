//
//  Formatter.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct Formatter {
    // MARK: - Formatting Values
    enum FormatType {
        case integer
        case oneDecimal
        case twoDecimals
        
        func formatString(for value: Double) -> String {
            switch self {
            case .integer:
                String(format: "%.0f", value)
            case .oneDecimal:
                String(format: "%.1f", value)
            case .twoDecimals:
                String(format: "%.2f", value)
            }
        }
    }
    
    enum Unit: String {
        case empty = ""
        case kcal
    }
    
    func determineFormatType(value: Double, unit: Unit,
                             roundToInt: Bool) -> FormatType {
        if unit == .kcal || roundToInt || value == floor(value) {
            return .integer
        } else if value * 10 == floor(value * 10) {
            return .oneDecimal
        } else {
            return .twoDecimals
        }
    }
    
    func formattedValue(_ value: Double, unit: Unit,
                        roundToInt: Bool = false,
                        includeSpace: Bool = true) -> String {
        let formatType = determineFormatType(value: value,
                                             unit: unit,
                                             roundToInt: roundToInt)
        let formattedValue = formatType.formatString(for: value)
        let finalValue = formattedValue.replacingOccurrences(of: ".",
                                                             with: ",")
        
        return unit == .empty ? finalValue :
        "\(finalValue)\(includeSpace ? " " : "")\(unit.rawValue)"
    }
}
