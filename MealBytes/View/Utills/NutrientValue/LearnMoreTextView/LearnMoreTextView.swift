//
//  LearnMoreTextView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 23.07.2026.
//

import SwiftUI

struct LearnMoreTextView: View {
    var body: some View {
        let fullText = "On a standard nutrition label in the United States, the % Daily Value (DV) tells you how much a nutrient in a serving of food contributes to a daily diet. \(2000.asWhole()) Calories a day is used for general nutrition advice.\n\nIn this context, % Daily Value is calculated as the total amount of a nutrient you've consumed divided by the recommended daily value. This can help you understand how your daily diet measures up against general nutritional advice. Learn more"
        
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (attributedString.string as NSString).range(
            of: "Learn more"
        )
        
        attributedString
            .addAttribute(
                .link,
                value: "https://www.fda.gov/food/nutrition-facts-label/how-understand-and-use-nutrition-facts-label",
                range: range
            )
        
        return HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text("*")
            
            Text(AttributedString(attributedString))
                .environment(\.openURL, OpenURLAction { url in
                    UIApplication.shared.open(url)
                    return .handled
                })
        }
        .font(.caption)
        .foregroundStyle(.secondary)
        .listRowInsets(.top, 10)
    }
}

#Preview {
    PreviewContentView.contentView
}
