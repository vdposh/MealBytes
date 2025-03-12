//
//  FoodResponse.swift
//  MealBytes
//
//  Created by Porshe on 07/03/2025.
//

import SwiftUI

struct FoodResponse: Decodable {
    let foods: [Food]
    let pageNumber: Int?
    let maxResults: Int?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        foods = try container.nestedContainer(
            keyedBy: CodingKeys.self,
            forKey: .foods).decode([Food].self, forKey: .food)
        pageNumber = try container.decodeIfPresent(
            Int.self, forKey: .pageNumber)
        maxResults = try container.decodeIfPresent(
            Int.self, forKey: .maxResults)
    }
    
    enum CodingKeys: String, CodingKey {
        case foods
        case food
        case searchExpression = "search_expression"
        case pageNumber = "page_number"
        case maxResults = "max_results"
    }
}
