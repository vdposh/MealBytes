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
        foods = try decoder.container(keyedBy: CodingKeys.self)
            .nestedContainer(keyedBy: FoodsCodingKeys.self, forKey: .foods)
            .decode([Food].self, forKey: .food)
    }
    
    private enum CodingKeys: String, CodingKey {
        case foods
    }
    
    private enum FoodsCodingKeys: String, CodingKey {
        case food
    }
}
