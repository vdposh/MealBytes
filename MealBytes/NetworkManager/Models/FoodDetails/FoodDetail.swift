//
//  FoodDetail.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct FoodDetail: Decodable {
    let foodId: Int
    let foodName: String
    var servings: Servings
    
    enum CodingKeys: String, CodingKey {
        case foodId = "food_id"
        case foodName = "food_name"
        case servings
    }
    
    init(foodId: Int, foodName: String, servings: Servings) {
        self.foodId = foodId
        self.foodName = foodName
        self.servings = servings
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let foodIdString = try container.decode(
            String.self,
            forKey: .foodId
        )
        self.foodId = Int(foodIdString) ?? 0
        
        self.foodName = try container.decode(
            String.self,
            forKey: .foodName
        )
        self.servings = try container.decode(
            Servings.self,
            forKey: .servings
        )
    }
}
