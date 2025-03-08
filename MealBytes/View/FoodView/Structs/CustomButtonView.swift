//
//  CustomButtonView.swift
//  MealBytes
//
//  Created by Porshe on 08/03/2025.
//

import SwiftUI

struct CustomButtonView: View {
    let title: String
    let description: String
    @Binding var showActionSheet: Bool
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Button(action: action) {
                HStack {
                    Text(description)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .resizable()
                        .frame(width: 10, height: 6)
                }
                .padding(.vertical, 5)
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.gray),
                    alignment: .bottom
                )
            }
            .buttonStyle(PlainButtonStyle())
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
