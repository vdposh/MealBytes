//
//  FoodResponse.swift
//  MealBytes
//
//  Created by Porshe on 07/03/2025.
//

import SwiftUI

struct FoodResponse: Decodable {
    let foods: [Food]

    private enum ContainerKeys: String, CodingKey {
        case foods
    }

    private enum FoodsKeys: String, CodingKey {
        case food
    }

    init(from decoder: Decoder) throws {
        let container = try decoder
            .container(keyedBy: ContainerKeys.self)
        let foodsContainer = try container
            .nestedContainer(keyedBy: FoodsKeys.self, forKey: .foods)
        
        foods = try foodsContainer.decode([Food].self, forKey: .food)
    }
}
