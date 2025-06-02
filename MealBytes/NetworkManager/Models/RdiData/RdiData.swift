//
//  RdiData.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
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
}
