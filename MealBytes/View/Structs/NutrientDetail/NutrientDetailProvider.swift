//
//  NutrientDetailProvider.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

struct NutrientDetailProvider {
    static func getNutrientDetails(
        from serving: Serving
    ) -> [(NutrientType, Double, Bool)] {
        [
            (.calories, serving.calories, false),
            (.servingSize(metricServingUnit: serving.metricServingUnit),
             serving.metricServingAmount, true),
            (.fat, serving.fat, false),
            (.saturatedFat, serving.saturatedFat, true),
            (.monounsaturatedFat, serving.monounsaturatedFat, true),
            (.polyunsaturatedFat, serving.polyunsaturatedFat, true),
            (.carbohydrates, serving.carbohydrate, false),
            (.sugar, serving.sugar, true),
            (.fiber, serving.fiber, true),
            (.protein, serving.protein, false),
            (.potassium, serving.potassium, true),
            (.sodium, serving.sodium, false),
            (.cholesterol, serving.cholesterol, true)
        ]
    }
    
    static func getCompactNutrientDetails(
        from serving: Serving
    ) -> [(String, Double, String)] {
        [
            (NutrientType.calories.title, serving.calories, ""),
            (NutrientType.fat.title, serving.fat, "g"),
            (NutrientType.protein.title, serving.protein, "g"),
            (NutrientType.carbohydrates.alternativeTitle,
             serving.carbohydrate, "g")
        ]
    }
}
