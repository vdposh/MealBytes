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
        alwaysRoundUp: Bool = false,
        fullUnitName: Bool = false
    ) -> String {
        let safeValue = value ?? 0.0
        
        if alwaysRoundUp {
            let intValue = Int(safeValue)
            let unitText = unit.description(for: safeValue, full: fullUnitName)
            return unit == .empty ? "\(intValue)" : "\(intValue) \(unitText)"
        } else {
            let cleaned = cleanDecimalString(String(format: "%.2f", safeValue))
            let finalValue = cleaned.preparedForLocaleDecimal
            let unitText = unit.description(for: safeValue, full: fullUnitName)
            return unit == .empty ? finalValue : "\(finalValue) \(unitText)"
        }
    }
    
    func roundedValue(_ value: Double, unit: Unit = .empty) -> String {
        let roundedValue = round(value)
        let unitText = unit.description(for: roundedValue)
        
        return unit == .empty
        ? String(format: "%.0f", roundedValue)
        : "\(String(format: "%.0f", roundedValue)) \(unitText)"
    }
    
    private func cleanDecimalString(_ string: String) -> String {
        if string.hasSuffix("00") {
            return String(string.dropLast(3))
        } else if string.hasSuffix("0") {
            return String(string.dropLast())
        } else {
            return string
        }
    }
    
    enum Unit: String {
        case empty
        case kcal
        case g
        case mg
        case ml
        case oz
        
        func description(for value: Double, full: Bool = false) -> String {
            let isSingular = abs(value) == 1
            switch self {
            case .empty:
                return ""
            case .kcal:
                return full ? "kilocalorie" + (isSingular ? "" : "s") : "kcal"
            case .g:
                return full ? "gram" + (isSingular ? "" : "s") : "g"
            case .mg:
                return full ? "milligram" + (isSingular ? "" : "s") : "mg"
            case .ml:
                return full ? "milliliter" + (isSingular ? "" : "s") : "ml"
            case .oz:
                return full ? "ounce" + (isSingular ? "" : "s") : "oz"
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
