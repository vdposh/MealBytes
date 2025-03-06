//
//  Nutrients.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct NutrientBlockView: View {
    let title: String
    let value: Double
    let unit: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white)
            HStack {
                Text(Formatter.formattedValue(value,
                                              unit: unit,
                                              roundToInt: true,
                                              includeSpace: false))
                    .lineLimit(1)
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 80, height: 77)
        .background(.green)
        .cornerRadius(15)
    }
}

struct NutrientDetailRow: View {
    let title: String
    let value: Double
    let unit: String
    let isSubValue: Bool
    
    init(title: String,
         value: Double,
         unit: String,
         isSubValue: Bool = false) {
        self.title = title
        self.value = value
        self.unit = unit
        self.isSubValue = isSubValue
    }
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(isSubValue ? .gray : .primary)
            Spacer()
            HStack {
                Text(Formatter.formattedValue(value, unit: unit))
                    .foregroundColor(isSubValue ? .gray : .primary)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    FoodView(
        food: Food(
            food_id: "39715",
            food_name: "Oats",
            food_description: ""
        )
    )
}
