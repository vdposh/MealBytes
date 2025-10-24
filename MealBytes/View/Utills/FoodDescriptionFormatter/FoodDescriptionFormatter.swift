//
//  FoodDescriptionFormatter.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 19/10/2025.
//

import SwiftUI

struct FoodDescriptionFormatter {
    static func normalizedDescription(from raw: String) -> String {
        let components = raw.split(
            separator: "|",
            maxSplits: 1,
            omittingEmptySubsequences: true
        )
        guard let firstPart = components.first else { return raw }
        
        let trimmed = firstPart.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let spaced = trimmed.replacingOccurrences(
            of: #"(?<=\d)(?=[a-zA-Z])"#,
            with: " ",
            options: .regularExpression
        )
        
        let gramRegex = try? NSRegularExpression(
            pattern: #"(\d+(?:\.\d+)?)\s*g"#,
            options: .caseInsensitive
        )
        let kcalRegex = try? NSRegularExpression(
            pattern: #"(\d+(?:\.\d+)?)\s*kcal"#,
            options: .caseInsensitive
        )
        
        func extractDouble(
            from match: NSTextCheckingResult?,
            in string: String,
            group: Int
        ) -> Double? {
            guard
                let match = match,
                let range = Range(match.range(at: group), in: string)
            else { return nil }
            
            return Double(string[range])
        }
        
        let gramMatch = gramRegex?.firstMatch(
            in: spaced,
            range: NSRange(spaced.startIndex..., in: spaced)
        )
        let kcalMatch = kcalRegex?.firstMatch(
            in: spaced,
            range: NSRange(spaced.startIndex..., in: spaced)
        )
        
        guard
            let grams = extractDouble(from: gramMatch, in: spaced, group: 1),
            let kcal = extractDouble(from: kcalMatch, in: spaced, group: 1),
            grams > 0
        else {
            return spaced
        }
        
        let normalizedKcal = Int((kcal / grams * 100).rounded())
        let kcalLabel = normalizedKcal == 1 ? "calorie" : "calories"
        return "Per 100 grams - \(normalizedKcal) \(kcalLabel)"
    }
}
