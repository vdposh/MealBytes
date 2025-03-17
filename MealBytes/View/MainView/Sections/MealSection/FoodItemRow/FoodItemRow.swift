//
//  FoodItemRow.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI

struct FoodItemRow: View {
    let mealItem: MealItem
    @ObservedObject var searchViewModel: SearchViewModel
    @ObservedObject var mainViewModel: MainViewModel
    let mealType: MealType
    
    private let formatter = Formatter()
    
    var body: some View {
        NavigationLink(
            destination: FoodView(
                food: Food(
                    searchFoodId: mealItem.foodId,
                    searchFoodName: mealItem.foodName,
                    searchFoodDescription: ""
                ),
                searchViewModel: searchViewModel,
                mainViewModel: mainViewModel,
                mealType: mealType,
                isFromSearchView: false,
                isFromFoodItemRow: true,
                amount: String(mealItem.amount),
                measurementDescription: mealItem.measurementDescription
            )
        ) {
            VStack(spacing: 10) {
                HStack {
                    Text(mealItem.foodName)
                        .lineLimit(1)
                        .fontWeight(.medium)
                        .frame(width: 120, alignment: .leading)
                    Text(mainViewModel.formattedServingSize(for: mealItem))
                        .foregroundColor(.gray)
                    Spacer()
                    Text(formatter.formattedValue(
                        mealItem.nutrients.value(for: .calories),
                        unit: .empty,
                        alwaysRoundUp: true
                    ))
                    .fontWeight(.medium)
                }
                HStack {
                    NutrientLabel(
                        label: "F",
                        value: mealItem.nutrients.value(for: .fat),
                        formatter: formatter
                    )
                    NutrientLabel(
                        label: "C",
                        value: mealItem.nutrients.value(for: .carbohydrates),
                        formatter: formatter
                    )
                    NutrientLabel(
                        label: "P",
                        value: mealItem.nutrients.value(for: .protein),
                        formatter: formatter
                    )
                    Spacer()
                }
            }
            .padding(.vertical, 5)
            .padding(.trailing, 5)
        }
    }
}

#Preview {
    MainView()
}

//#Preview {
//    MealSection(
//        mealType: .breakfast,
//        title: "Breakfast",
//        iconName: "sunrise.fill",
//        color: .customGreen,
//        calories: 500.0,
//        fats: 20.0,
//        proteins: 30.0,
//        carbohydrates: 50.0,
//        foodItems: [
//            MealItem(
//                foodId: 1,
//                foodName: "Oatmeal",
//                portionUnit: "g",
//                nutrients: [
//                    .calories: 150.0,
//                    .fat: 3.0,
//                    .protein: 5.0,
//                    .carbohydrates: 27.0
//                ],
//                measurementDescription: "1 cup (100g)",
//                amount: 100.0
//            ),
//            MealItem(
//                foodId: 2,
//                foodName: "Banana",
//                portionUnit: "g",
//                nutrients: [
//                    .calories: 105.0,
//                    .fat: 0.3,
//                    .protein: 1.3,
//                    .carbohydrates: 27.0
//                ],
//                measurementDescription: "1 medium (120g)",
//                amount: 120.0
//            )
//        ],
//        mainViewModel: MainViewModel()
//    )
//}
