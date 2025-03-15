//
//  MealSection.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct MealSection: View {
    let title: String
    let iconName: String
    let color: Color
    let calories: Double
    let fats: Double
    let proteins: Double
    let carbohydrates: Double
    let foodItems: [MealItem]
    
    @State private var isExpanded: Bool = false
    private let formatter = Formatter()
    
    var body: some View {
        Section {
            NavigationLink(destination: SearchView()) {
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: iconName)
                            .foregroundColor(color)
                        Text(title)
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
                        Text("P")
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .padding(.leading, 5)
                        Text(formatter.formattedValue(proteins, unit: .empty))
                            .foregroundColor(.gray)
                            .font(.footnote)
                        Text("C")
                            .foregroundColor(.gray)
                            .font(.footnote)
                            .padding(.leading, 5)
                        Text(formatter.formattedValue(carbohydrates, unit: .empty))
                            .foregroundColor(.gray)
                            .font(.footnote)
                        Spacer()
                        Text("RDA")
                            .foregroundColor(.gray)
                            .font(.footnote)
                    }
                }
                .padding(.vertical, 5)
                .padding(.trailing, 5)
            }
            
            switch isExpanded {
            case true:
                ForEach(foodItems) { item in
                    FoodItemRow(
                        foodName: item.foodName,
                        portionSize: item.portionSize,
                        calories: item.calories,
                        fats: item.fats,
                        proteins: item.proteins,
                        carbohydrates: item.carbohydrates,
                        rsk: item.rsk
                    )
                }
                ShowHideButtonView(isExpanded: isExpanded) {
                    isExpanded.toggle()
                }
            case false:
                ShowHideButtonView(isExpanded: isExpanded) {
                    isExpanded.toggle()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
