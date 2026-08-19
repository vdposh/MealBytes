//
//  BookmarkMetadata.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/10/2025.
//

import SwiftUI

struct BookmarkMetadata: Codable {
    let foodId: Int
    let foodName: String
    let mealType: MealType
    let amount: String
    let servingDescription: String
    let calories: Double
    let fat: Double
    let carbs: Double
    let protein: Double
    let formattedText: String
}
