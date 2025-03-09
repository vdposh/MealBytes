//
//  FoodResponse.swift
//  MealBytes
//
//  Created by Porshe on 07/03/2025.
//

import SwiftUI

struct FoodResponse: Decodable {
    let foods: [Food]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        foods = try container.nestedContainer(keyedBy: CodingKeys.self,
                                              forKey: .foods)
        .decode([Food].self, forKey: .food)
    }
    
    private enum CodingKeys: String, CodingKey {
        case foods
        case food
    }
}
