//
//  FoodDetail.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct FoodDetailResponse: Decodable {
    var food: FoodDetail
}

struct FoodDetail: Decodable {
    let food_id: String
    let food_name: String
    var servings: Servings
}

struct Servings: Decodable {
    var serving: [Serving]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            serving = try container.decode([Serving].self,
                                           forKey: .serving)
        } catch DecodingError.typeMismatch {
            serving = [try container.decode(Serving.self,
                                            forKey: .serving)]
        }
    }

    private enum CodingKeys: String, CodingKey {
        case serving
    }
}
