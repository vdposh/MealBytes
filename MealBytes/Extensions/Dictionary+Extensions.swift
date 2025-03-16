//
//  Dictionary+Extensions.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

extension Dictionary where Key == NutrientType, Value == Double {
    func value(for type: NutrientType) -> Double {
        self[type] ?? 0.0
    }
}
