//
//  NutrientType.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

enum NutrientType: String, Identifiable, CaseIterable {
    var id: String { self.rawValue }
    
    case calories,
         servingSize,
         fat,
         saturatedFat,
         monounsaturatedFat,
         polyunsaturatedFat,
         carbohydrates,
         sugar,
         fiber,
         protein,
         potassium,
         sodium,
         cholesterol
    
    var title: String {
        switch self {
        case .calories: "Calories"
        case .servingSize: "Serving size"
        case .fat: "Fat"
        case .saturatedFat: "Saturated Fat"
        case .monounsaturatedFat: "Monounsaturated Fat"
        case .polyunsaturatedFat: "Polyunsaturated Fat"
        case .carbohydrates: "Carbohydrates"
        case .sugar: "Sugar"
        case .fiber: "Fiber"
        case .protein: "Protein"
        case .potassium: "Potassium"
        case .sodium: "Sodium"
        case .cholesterol: "Cholesterol"
        }
    }
    
    var alternativeTitle: String {
        switch self {
        case .carbohydrates: "Carb"
        default: title
        }
    }
    
    var alternativeNutrientsTitle: String {
        switch self {
        case .fat: "F"
        case .protein: "P"
        case .carbohydrates: "C"
        default: title
        }
    }
    
    private var baseUnit: String {
        switch self {
        case .calories: "kcal"
        case .servingSize: "g"
        case .fat,
                .saturatedFat,
                .monounsaturatedFat,
                .polyunsaturatedFat,
                .carbohydrates,
                .sugar,
                .fiber,
                .protein: "g"
        case .potassium,
                .sodium,
                .cholesterol: "mg"
        }
    }
    
    func unit(for serving: Serving) -> String {
        switch self {
        case .servingSize:
            return serving.metricServingUnit
        default:
            return baseUnit
        }
    }
    
    var alternativeUnit: String {
        baseUnit
    }
    
    var isServingSize: Bool {
        self == .servingSize
    }
}
