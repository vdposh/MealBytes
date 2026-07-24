//
//  NutrientType.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/03/2025.
//

import SwiftUI

enum NutrientType: String, Identifiable, CaseIterable {
    var id: String { self.rawValue }
    
    case servingSize,
         calories,
         fat,
         saturatedFat,
         transFat,
         polyunsaturatedFat,
         monounsaturatedFat,
         cholesterol,
         sodium,
         carbohydrate,
         fiber,
         sugar,
         addedSugars,
         protein,
         vitaminD,
         calcium,
         iron,
         potassium
    
    var title: String {
        switch self {
        case .calories: "Calories"
        case .fat: "Fat"
        case .saturatedFat: "Saturated Fat"
        case .transFat: "Trans Fat"
        case .polyunsaturatedFat: "Polyunsaturated Fat"
        case .monounsaturatedFat: "Monounsaturated Fat"
        case .cholesterol: "Cholesterol"
        case .sodium: "Sodium"
        case .carbohydrate: "Carbohydrate"
        case .fiber: "Dietary Fiber"
        case .sugar: "Total Sugars"
        case .addedSugars: "Includes Added Sugars"
        case .protein: "Protein"
        case .vitaminD: "Vitamin D"
        case .calcium: "Calcium"
        case .iron: "Iron"
        case .potassium: "Potassium"
        case .servingSize: "Serving size"
        }
    }
    
    var alternativeTitle: String {
        switch self {
        case .carbohydrate: "Carbs"
        default: title
        }
    }

    var longTitle: String {
        switch self {
        case .carbohydrate: "Total Carbohydrates"
        case .fat: "Total Fat"
        default: title
        }
    }
    
    var isSubValue: Bool {
        switch self {
        case .saturatedFat,
                .transFat,
                .polyunsaturatedFat,
                .monounsaturatedFat,
                .sugar,
                .addedSugars,
                .fiber,
                .potassium,
                .vitaminD,
                .calcium,
                .iron:
            true
        default:
            false
        }
    }
    
    var alternativeIsSubValue: Bool {
        switch self {
        case .saturatedFat,
                .transFat,
                .polyunsaturatedFat,
                .monounsaturatedFat,
                .sugar,
                .addedSugars,
                .fiber:
            true
        default: false
        }
    }
    
    var baseUnit: String {
        switch self {
        case .calories: "kcal"
        case .fat,
                .saturatedFat,
                .transFat,
                .polyunsaturatedFat,
                .monounsaturatedFat,
                .carbohydrate,
                .sugar,
                .addedSugars,
                .fiber,
                .protein: "g"
        case .potassium,
                .sodium,
                .cholesterol,
                .calcium,
                .iron: "mg"
        case .vitaminD: "mcg"
        case .servingSize: "g"
        }
    }
    
    var leadingPadding: CGFloat {
        switch self {
        case .addedSugars: 32
        case .saturatedFat,
                .transFat,
                .polyunsaturatedFat,
                .monounsaturatedFat,
                .sugar,
                .fiber:
            16
        default: 0
        }
    }
    
    func unit(for serving: Serving) -> String {
        switch self {
        case .servingSize:
            if serving.metricServingUnit.isEmpty {
                return "ml"
            } else {
                return serving.metricServingUnit
            }
        default: return baseUnit
        }
    }
    
    var unit: String {
        baseUnit
    }
}

#Preview {
    PreviewContentView.contentView
}
