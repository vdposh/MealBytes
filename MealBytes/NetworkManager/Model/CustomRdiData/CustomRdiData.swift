//
//  CustomRdiData.swift
//  MealBytes
//
//  Created by Porshe on 23/03/2025.
//

import SwiftUI

struct CustomRdiData: Codable {
    var calories: String
    var fat: String
    var carbohydrate: String
    var protein: String
    var isUsingPercentage: Bool

    init(calories: String,
         fat: String,
         carbohydrate: String,
         protein: String,
         isUsingPercentage: Bool) {
        self.calories = calories
        self.fat = fat
        self.carbohydrate = carbohydrate
        self.protein = protein
        self.isUsingPercentage = isUsingPercentage
    }

    init(data: [String: Any]) throws {
        guard
            let calories = data["calories"] as? String,
            let fat = data["fat"] as? String,
            let carbohydrate = data["carbohydrate"] as? String,
            let protein = data["protein"] as? String,
            let isUsingPercentage = data["isUsingPercentage"] as? Bool
        else {
            throw AppError.decoding
        }

        self.calories = calories
        self.fat = fat
        self.carbohydrate = carbohydrate
        self.protein = protein
        self.isUsingPercentage = isUsingPercentage
    }
}
