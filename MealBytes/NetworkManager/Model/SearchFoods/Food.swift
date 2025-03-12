//
//  Food.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct Food: Decodable {
    let searchFoodId: String
    let searchFoodName: String
    let searchFoodDescription: String
    
    enum CodingKeys: String, CodingKey {
        case searchFoodId = "food_id",
             searchFoodName = "food_name",
             searchFoodDescription = "food_description"
    }
    
    var parsedDescription: String? {
        let components = searchFoodDescription.split(
            separator: "|", maxSplits: 1, omittingEmptySubsequences: true)
        guard let firstPart = components.first else { return nil }
        return String(firstPart.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
