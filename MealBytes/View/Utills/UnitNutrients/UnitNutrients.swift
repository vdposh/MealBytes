//
//  UnitNutrients.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

enum UnitNutrients: String {
    case empty
    case kcal
    case g
    case mg
    case ml
    case oz
    
    func description(for value: Double, full: Bool = false) -> String {
        let isSingular = abs(value) == 1
        switch self {
        case .empty:
            return ""
        case .kcal:
            return full ? "kilocalorie" + (isSingular ? "" : "s") : "kcal"
        case .g:
            return full ? "gram" + (isSingular ? "" : "s") : "g"
        case .mg:
            return full ? "milligram" + (isSingular ? "" : "s") : "mg"
        case .ml:
            return full ? "milliliter" + (isSingular ? "" : "s") : "ml"
        case .oz:
            return full ? "ounce" + (isSingular ? "" : "s") : "oz"
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
