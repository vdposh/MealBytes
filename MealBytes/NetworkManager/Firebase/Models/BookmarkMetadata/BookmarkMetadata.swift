//
//  BookmarkMetadata.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 30/10/2025.
//

import SwiftUI

struct BookmarkMetadata: Codable {
    let foodId: Int
    let mealType: MealType
    let lastAmount: String
    let lastServingDescription: String
}
