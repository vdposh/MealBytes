//
//  FoodDetail.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct FoodDetail: Decodable {
    let food_id: String
    let food_name: String
    var servings: Servings
}
