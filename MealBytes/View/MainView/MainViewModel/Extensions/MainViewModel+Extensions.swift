//
//  MainViewModel+Extensions.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

extension MainViewModel {
    func value(for type: NutrientType) -> Double {
        nutrientSummaries[type] ?? 0.0
    }
}
