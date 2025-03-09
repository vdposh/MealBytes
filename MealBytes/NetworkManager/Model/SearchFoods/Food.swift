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
        case searchFoodId = "food_id", searchFoodName = "food_name", 
             searchFoodDescription = "food_description"
    }
}
