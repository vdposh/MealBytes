//
//  RdiData.swift
//  MealBytes
//
//  Created by Porshe on 24/03/2025.
//

import SwiftUI

struct RdiData: Codable {
    let calculatedRdi: String
    let age: String
    let selectedGender: String
    let selectedActivity: String
    let weight: String
    let selectedWeightUnit: String
    let height: String
    let selectedHeightUnit: String
    
    init(
        calculatedRdi: String = "",
        age: String = "",
        selectedGender: String = "",
        selectedActivity: String = "",
        weight: String = "",
        selectedWeightUnit: String = "kg",
        height: String = "",
        selectedHeightUnit: String = "cm"
    ) {
        self.calculatedRdi = calculatedRdi
        self.age = age
        self.selectedGender = selectedGender
        self.selectedActivity = selectedActivity
        self.weight = weight
        self.selectedWeightUnit = selectedWeightUnit
        self.height = height
        self.selectedHeightUnit = selectedHeightUnit
    }
}
