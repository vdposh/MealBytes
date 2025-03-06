//
//  Food.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct FoodResponse: Decodable {
    let foods: Foods
}

struct Foods: Decodable {
    let food: [Food]
}

struct Food: Decodable {
    let food_id: String
    let food_name: String
    let food_description: String
}
