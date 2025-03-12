//
//  NutrientType.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

enum NutrientType: String, Identifiable {
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
    
    func unit(for serving: Serving) -> String {
        switch self {
        case .calories: "kcal"
        case .servingSize: serving.metricServingUnit
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
}
