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
    
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            NavigationLink(destination: SearchView(
                mainViewModel: mainViewModel)) {
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
            
            if isExpanded {
                ForEach(foodItems) { item in
                    FoodItemRow(
                        foodName: item.foodName,
                        portionSize: item.nutrients[.servingSize] ?? 0.0,
                        portionUnit: item.portionUnit,
                        calories: item.nutrients[.calories] ?? 0.0,
                        fats: item.nutrients[.fat] ?? 0.0,
                        proteins: item.nutrients[.protein] ?? 0.0,
                        carbohydrates: item.nutrients[.carbohydrates] ?? 0.0
                    )
                }
            }
            
            ShowHideButtonView(isExpanded: isExpanded) {
                isExpanded.toggle()
            }
        }
    }
}

#Preview {
    MealSection(
        title: "Breakfast",
        iconName: "sunrise.fill",
        color: .customBreakfast,
        calories: 500.0,
        fats: 20.0,
        proteins: 30.0,
        carbohydrates: 50.0,
        foodItems: [
            MealItem(
                foodId: 1,
                foodName: "Oatmeal",
                portionUnit: "g",
                nutrients: [
                    .calories: 150.0,
                    .fat: 3.0,
                    .protein: 5.0,
                    .carbohydrates: 27.0
                ],
                servingDescription: "1 cup (100g)",
                amount: 100.0
            ),
            MealItem(
                foodId: 2,
                foodName: "Banana",
                portionUnit: "g",
                nutrients: [
                    .calories: 105.0,
                    .fat: 0.3,
                    .protein: 1.3,
                    .carbohydrates: 27.0
                ],
                servingDescription: "1 medium (120g)",
                amount: 120.0
            )
        ],
        mainViewModel: MainViewModel()
    )
}
