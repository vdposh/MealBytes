//
//  CustomTextFieldView.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

import SwiftUI

struct CustomTextFieldView: View {
    let title: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(title)")
                .font(.caption)
                .foregroundColor(.gray) + Text("*").foregroundColor(.customRed)
            TextField("", text: $text)
                .keyboardType(.decimalPad)
                .padding(.vertical, 5)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray),
                    alignment: .bottom
                )
        }
    }
}

#Preview {
    FoodView(
        food: Food(
            food_id: "39715",
            food_name: "Oats, 123",
            food_description: ""
        )
    )
}
