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
    
    enum CodingKeys: String, CodingKey {
        case calculatedRdi,
             age,
             selectedGender,
             selectedActivity,
             weight,
             selectedWeightUnit,
             height,
             selectedHeightUnit
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        func decodeString(forKey key: CodingKeys) -> String {
            (try? container.decode(String.self, forKey: key)) ?? ""
        }
        
        calculatedRdi = decodeString(forKey: .calculatedRdi)
        age = decodeString(forKey: .age)
        selectedGender = decodeString(forKey: .selectedGender)
        selectedActivity = decodeString(forKey: .selectedActivity)
        weight = decodeString(forKey: .weight)
        selectedWeightUnit = decodeString(forKey: .selectedWeightUnit)
        height = decodeString(forKey: .height)
        selectedHeightUnit = decodeString(forKey: .selectedHeightUnit)
    }
    
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
