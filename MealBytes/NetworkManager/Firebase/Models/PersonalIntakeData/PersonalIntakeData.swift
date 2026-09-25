//
//  PersonalIntakeData.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 24/03/2025.
//

import SwiftUI

struct PersonalIntakeData: Codable {
    let calculatedPersonalIntake: String
    let age: String
    let selectedSex: String
    let selectedActivity: String
    let weight: String
    let selectedWeightUnit: String
    let height: String
    let selectedHeightUnit: String
    let selectedWeightGoal: String
}
