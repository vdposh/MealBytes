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
                Text("\(formatter.formattedValue(portionSize, unit: .empty)) \(portionUnit)")
                    .foregroundColor(.gray)
                    .frame(width: 180, alignment: .leading)
                Spacer()
                Text(formatter.formattedValue(calories, unit: .empty))
            }
            HStack {
                Text("F")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Text(formatter.formattedValue(fats, unit: .empty))
                    .foregroundColor(.gray)
                    .font(.footnote)
                Text("C")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.leading, 5)
                Text(formatter.formattedValue(carbohydrates, unit: .empty))
                    .foregroundColor(.gray)
                    .font(.footnote)
                Text("P")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.leading, 5)
                Text(formatter.formattedValue(proteins, unit: .empty))
                    .foregroundColor(.gray)
                    .font(.footnote)
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
        calories: 12032.0,
        fats: 3.2,
        proteins: 6.8,
        carbohydrates: 4.7
    )
}
