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
        
        func formatString() -> String {
            switch self {
            case .integer: "%.0f"
            case .oneDecimal: "%.1f"
            case .twoDecimals: "%.2f"
            }
        }
    }
    
    enum Unit: String {
        case empty = ""
        case kcal
        case g
        case mg
    }
    
    func determineFormatType(value: Double, unit: Unit,
                             roundToInt: Bool) -> FormatType {
        switch true {
        case unit == .kcal, roundToInt, value == floor(value):
                .integer
        case value * 10 == floor(value * 10):
                .oneDecimal
        default:
                .twoDecimals
        }
    }
    
    func formattedValue(_ value: Double, unit: Unit,
                        roundToInt: Bool = false,
                        includeSpace: Bool = true) -> String {
        let formatType = determineFormatType(value: value,
                                             unit: unit,
                                             roundToInt: roundToInt)
        let formattedValue = "\(value)".formatted(with:
                                                    formatType.formatString())
        let finalValue = formattedValue.replacingOccurrences(of: ".",
                                                             with: ",")
        
        return unit == .empty ? finalValue :
        "\(finalValue)\(includeSpace ? " " : "")\(unit.rawValue)"
    }
}
