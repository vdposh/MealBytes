//
//  FoodItemRow.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct FoodItemRow: View {
    let foodName: String
    let portionSize: Double
    let portionUnit: String
    let calories: Double
    let fats: Double
    let proteins: Double
    let carbohydrates: Double
    private let formatter = Formatter()
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(foodName)
                    .lineLimit(1)
                    .fontWeight(.medium)
                    .frame(width: 120, alignment: .leading)
                Text("\(formatter.formattedValue(portionSize, unit: .empty)) \(portionUnit)")
                    .foregroundColor(.gray)
                    .frame(width: 150, alignment: .leading)
                Spacer()
                Text(
                    formatter.formattedValue(
                        calories,
                        unit: .empty,
                        alwaysRoundUp: true
                    )
                )
                .fontWeight(.medium)
            }
            HStack {
                NutrientLabel(
                    label: "F", value: fats, formatter: formatter)
                NutrientLabel(
                    label: "C", value: carbohydrates, formatter: formatter)
                    .padding(.leading, 5)
                NutrientLabel(
                    label: "P", value: proteins, formatter: formatter)
                    .padding(.leading, 5)
                Spacer()
            }
        }
        .padding(.vertical, 5)
        .padding(.trailing, 5)
    }
}

#Preview {
    FoodItemRow(
        foodName: "Whole Milk",
        portionSize: 200.0, portionUnit: "g",
        calories: 120.0,
        fats: 3.2,
        proteins: 6.8,
        carbohydrates: 4.7
    )
}
