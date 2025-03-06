//
//  Formatter.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct Formatter {
    //форматируем значения после запятой
    static func formattedValue(_ value: Double,
                               unit: String,
                               roundToInt: Bool = false,
                               includeSpace: Bool = true) -> String {
        let formattedValue: String
        if unit.isEmpty || unit == "kcal" {
            formattedValue = String(format: "%.0f", value)
        } else if roundToInt || value == floor(value) {
            formattedValue = String(format: "%.0f", value)
        } else if value * 10 == floor(value * 10) {
            formattedValue = String(format: "%.1f", value)
        } else {
            formattedValue = String(format: "%.2f", value)
        }
        
        if unit.isEmpty {
            return formattedValue
        } else {
            return includeSpace ? "\(formattedValue) \(unit)"
            : "\(formattedValue)\(unit)"
        }
    }
    //форматируем, чтобы 1г = 1г, 1мл = 1мл. Порции те же: 1 порция = 1 порция
    static func calculateAmountValue(_ amount: String,
                                     measurementDescription: String) -> Double {
        if amount.isEmpty || amount == "0" {
            return 0
        }
        let amountValue = Double(amount) ?? 0
        return measurementDescription == "g" ||
        measurementDescription == "ml" ? amountValue * 0.01 : amountValue
    }
}
