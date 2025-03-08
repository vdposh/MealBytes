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
    }
    
    static func determineFormatType(value: Double,
                                    unit: String,
                                    roundToInt: Bool) -> FormatType {
        if unit.isEmpty ||
            unit == "kcal" || roundToInt || value == floor(value) {
            .integer
        } else if value * 10 == floor(value * 10) {
            .oneDecimal
        } else {
            .twoDecimals
        }
    }
    
    static func formattedValue(_ value: Double,
                               unit: String,
                               roundToInt: Bool = false,
                               includeSpace: Bool = true) -> String {
        let formatType = determineFormatType(value: value,
                                             unit: unit,
                                             roundToInt: roundToInt)
        
        let formattedValue: String
        switch formatType {
        case .integer:
            formattedValue = String(format: "%.0f", value)
        case .oneDecimal:
            formattedValue = String(format: "%.1f", value)
        case .twoDecimals:
            formattedValue = String(format: "%.2f", value)
        }
        
        let finalValue = formattedValue.replacingOccurrences(of: ".", with: ",")
        
        return unit.isEmpty ? 
        finalValue : "\(finalValue)\(includeSpace ? " " : "")\(unit)"
    }
    
    // MARK: - Calculating Amounts
    static func calculateAmountValue(_ amount: String,
                                     measurementDescription: String) -> Double {
        if amount.isEmpty || amount == "0" {
            return 0
        }
        let amountValue = Double(amount.replacingOccurrences(of: ",",
                                                             with: ".")) ?? 0
        return measurementDescription == "g" ||
        measurementDescription == "ml" ? amountValue * 0.01 : amountValue
    }
}
