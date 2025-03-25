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
    
    enum CodingKeys: String, CodingKey {
        case calories
        case fat
        case carbohydrate
        case protein
        case isUsingPercentage
    }
}
