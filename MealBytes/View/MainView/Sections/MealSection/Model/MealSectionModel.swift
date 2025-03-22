//
//  MealSectionModel.swift
//  MealBytes
//
//  Created by Porshe on 17/03/2025.
//

import SwiftUI

struct MealSectionModel {
    let mealType: MealType
    let title: String
    let iconName: String
    let color: Color
    let calories: Double
    let fat: Double
    let protein: Double
    let carbohydrate: Double
    let foodItems: [MealItem]
}
