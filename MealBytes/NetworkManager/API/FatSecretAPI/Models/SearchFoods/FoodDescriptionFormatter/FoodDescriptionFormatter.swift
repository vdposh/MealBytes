//
//  FoodDescriptionFormatter.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/10/2025.
//

import SwiftUI

struct FoodDescriptionFormatter {
    static func normalizedDescription(
        from raw: String
    ) -> (
        description: String,
        calories: Double,
        fat: Double,
        carbs: Double,
        protein: Double
    )? {
        
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var description = trimmed
        description = description.replacingOccurrences(of: "Per ", with: "")
        
        if let range = description.range(of: " - ") {
            description = String(description[..<range.lowerBound])
        } else if let range = description.range(of: " | ") {
            description = String(description[..<range.lowerBound])
        }
        
        description = description.trimmingCharacters(in: .whitespaces)
        
        let hasGramsInPer: Bool = {
            let lowercased = trimmed.lowercased()
            guard let perRange = lowercased.range(of: "per ") else {
                return false
            }
            let afterPer = String(lowercased[perRange.upperBound...])
            
            let digits = "0123456789."
            var numberString = ""
            var foundDigit = false
            
            for char in afterPer {
                if digits.contains(char) {
                    numberString.append(char)
                    foundDigit = true
                } else if foundDigit {
                    break
                }
            }
            
            guard let _ = Double(numberString) else { return false }
            
            let afterNumber = afterPer.replacingOccurrences(
                of: numberString,
                with: ""
            )
            let trimmedAfterNumber = afterNumber.trimmingCharacters(
                in: .whitespaces
            )
            
            return trimmedAfterNumber.hasPrefix("g")
        }()
        
        func extractValue(for key: String, in text: String) -> Double {
            let lowercased = text.lowercased()
            let searchKey = key.lowercased()
            
            guard let range = lowercased.range(of: searchKey) else {
                return 0
            }
            
            let afterKey = String(text[range.upperBound...])
            
            let digits = "0123456789."
            var numberString = ""
            var foundDigit = false
            
            for char in afterKey {
                if digits.contains(char) {
                    numberString.append(char)
                    foundDigit = true
                } else if foundDigit {
                    break
                }
            }
            
            return Double(numberString) ?? 0
        }
        
        let kcal = extractValue(for: "Calories", in: trimmed)
        let grams = extractValue(for: "Per", in: trimmed)
        let fat = extractValue(for: "Fat", in: trimmed)
        let carbs = extractValue(for: "Carbs", in: trimmed)
        let protein = extractValue(for: "Protein", in: trimmed)
        
        if hasGramsInPer && grams > 0 {
            let kcalPer100 = kcal / grams * 100
            let fatPer100 = fat / grams * 100
            let carbsPer100 = carbs / grams * 100
            let proteinPer100 = protein / grams * 100
            
            return (
                "100 g",
                kcalPer100,
                fatPer100,
                carbsPer100,
                proteinPer100
            )
        }
        
        return (description, kcal, fat, carbs, protein)
    }
}

#Preview {
    PreviewContentView.contentView
}
