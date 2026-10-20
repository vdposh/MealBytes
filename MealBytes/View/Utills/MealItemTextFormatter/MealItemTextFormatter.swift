//
//  MealItemTextFormatter.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 11/10/2026.
//

import SwiftUI

enum MealItemTextFormatter {
    static func format(
        amountValue: Double,
        measurement: String,
        servingSize: Double,
        unit: String
    ) -> String {
        let formattedAmount = amountValue.asDecimal()
        
        if amountValue == 0 {
            if measurement == "g" {
                return "grams"
            }
            return measurement
        }
        
        let displayMeasurement: String
        if measurement == "g" {
            displayMeasurement = "g"
        } else if measurement == "ml" {
            displayMeasurement = "ml"
        } else if measurement.starts(with: "serving") {
            displayMeasurement = amountValue == 1 ? "serving" : "servings"
        } else {
            displayMeasurement = measurement.pluralized(for: amountValue)
        }
        
        let resolvedUnit: String
        if measurement == "g" {
            resolvedUnit = "g"
        } else if measurement == "ml" {
            resolvedUnit = "ml"
        } else {
            resolvedUnit = unit
        }
        
        if servingSize == 0 {
            return "\(formattedAmount) \(displayMeasurement)"
        }
        
        if measurement == "g" || measurement == "ml" {
            return "\(formattedAmount) \(resolvedUnit)"
        }
        
        let totalSize = servingSize * amountValue
        return "\(formattedAmount) \(displayMeasurement) (\(totalSize.asDecimal()) \(resolvedUnit))"
    }
}
