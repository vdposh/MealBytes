//
//  Food.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct Food: Decodable {
    let searchFoodId: Int
    let searchFoodName: String
    let searchFoodDescription: String
    
    enum CodingKeys: String, CodingKey {
        case searchFoodId = "food_id",
             searchFoodName = "food_name",
             searchFoodDescription = "food_description"
    }
    
    init(searchFoodId: Int,
         searchFoodName: String,
         searchFoodDescription: String) {
        self.searchFoodId = searchFoodId
        self.searchFoodName = searchFoodName
        self.searchFoodDescription = searchFoodDescription
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let searchFoodIdString = try container.decode(
            String.self, forKey: .searchFoodId)
        self.searchFoodId = Int(searchFoodIdString) ?? 0
        
        self.searchFoodName = try container.decode(
            String.self, forKey: .searchFoodName)
        self.searchFoodDescription = try container.decode(
            String.self, forKey: .searchFoodDescription)
    }
    
    var parsedDescription: String? {
        let components = searchFoodDescription.split(
            separator: "|", maxSplits: 1, omittingEmptySubsequences: true)
        guard let firstPart = components.first else { return nil }
        return String(firstPart.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
