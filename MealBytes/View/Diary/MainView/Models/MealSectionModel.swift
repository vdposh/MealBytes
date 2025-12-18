//
//  MealSectionModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 17/03/2025.
//

import SwiftUI

struct MealSectionModel {
    let mealType: MealType
    let title: String
    let iconName: String
    let calories: Double
    let fat: Double
    let protein: Double
    let carbohydrate: Double
    let foodItems: [MealItem]
}
