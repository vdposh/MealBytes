//
//  FoodListFormatter.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 18.06.2026.
//

import SwiftUI

struct FoodListFormatter {
    private let font: UIFont
    private let maxWidth: CGFloat
    
    init(font: UIFont = .preferredFont(forTextStyle: .subheadline),
         maxWidth: CGFloat = UIScreen.currentSize.width - 32) {
        self.font = font
        self.maxWidth = maxWidth
    }
    
    func format(foodNames: [String]) -> String {
        let totalCount = foodNames.count
        guard totalCount > 0 else { return "" }
        
        if totalCount == 1 {
            return foodNames[0]
        }
        
        if totalCount == 2 {
            let text = "\(foodNames[0]) and \(foodNames[1])"
            if fitsInTwoLines(text) {
                return text
            }
            return "\(foodNames[0]) and 1 more"
        }
        
        if totalCount == 3 {
            let text = "\(foodNames[0]), \(foodNames[1]) and \(foodNames[2])"
            if fitsInTwoLines(text) {
                return text
            }
            let text2 = "\(foodNames[0]), \(foodNames[1]) and 1 more"
            if fitsInTwoLines(text2) {
                return text2
            }
            return "\(foodNames[0]) and 2 more"
        }
        
        for count in stride(from: min(totalCount - 1, 5), through: 1, by: -1) {
            let displayNames = foodNames.prefix(count)
            let remainingCount = totalCount - count
            var text = displayNames.joined(separator: ", ")
            text += " and \(remainingCount) more"
            
            if fitsInTwoLines(text) {
                return text
            }
        }
        
        return "\(foodNames[0]) and \(totalCount - 1) more"
    }
    
    // MARK: - Private Methods
    private func fitsInTwoLines(_ text: String) -> Bool {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        let lines = ceil(size.width / maxWidth)
        return lines <= 2 && size.width > 0
    }
}

#Preview {
    PreviewContentView.contentView
}
