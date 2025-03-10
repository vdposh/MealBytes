//
//  NutrientType.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

enum NutrientType {
    case calories
    case servingSize(metricServingUnit: String)
    case fat
    case saturatedFat
    case monounsaturatedFat
    case polyunsaturatedFat
    case carbohydrates
    case sugar
    case fiber
    case protein
    case potassium
    case sodium
    case cholesterol
    
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
    
    var unit: String {
        switch self {
        case .calories: "kcal"
        case .servingSize(let metricServingUnit): metricServingUnit
        case .fat, .saturatedFat, .monounsaturatedFat, .polyunsaturatedFat,
                .carbohydrates, .sugar, .fiber, .protein: "g"
        case .potassium, .sodium, .cholesterol: "mg"
        }
    }
    
    var alternativeUnit: String {
          switch self {
          case .calories: ""
          default: unit
          }
      }
}
