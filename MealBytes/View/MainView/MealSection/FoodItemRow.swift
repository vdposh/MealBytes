//
//  FoodItemRow.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct FoodItemRow: View {
    let foodName: String
    let portionSize: String
    let calories: String
    let nutrition: [String: String]
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text(foodName)
                Text(portionSize)
                    .foregroundColor(.gray)
                    .padding(.leading)
                Spacer()
                Text("\(calories) ккал")
            }
            
            HStack {
                Text("F")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Text("жиры")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Text("P")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.leading)
                Text("белки")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Text("C")
                    .foregroundColor(.gray)
                    .font(.footnote)
                    .padding(.leading)
                Text("углеводы")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Spacer()
                Text("РСК")
                    .foregroundColor(.gray)
                    .font(.footnote)
            }
        }
        .padding(.vertical, 5)
        .padding(.trailing, 5)
    }
}

#Preview {
    FoodItemRow(
        foodName: "1",
        portionSize: "1",
        calories: "1",
        nutrition: [:]
    )
}
