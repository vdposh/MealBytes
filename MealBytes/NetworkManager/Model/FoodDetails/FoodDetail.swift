//
//  FoodDetail.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct FoodDetail: Decodable {
    let foodId: String
    let foodName: String
    var servings: Servings
    
    enum CodingKeys: String, CodingKey {
        case foodId = "food_id",
             foodName = "food_name",
             servings
    }
}
