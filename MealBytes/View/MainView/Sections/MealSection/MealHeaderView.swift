//
//  MealHeaderView.swift
//  MealBytes
//
//  Created by Porshe on 16/03/2025.
//

import SwiftUI

struct MealHeaderView: View {
    let mealType: MealType
    let title: String
    let iconName: String
    let color: Color
    let calories: Double
    let fats: Double
    let proteins: Double
    let carbohydrates: Double
    let foodItems: [MealItem]
    @ObservedObject var mainViewModel: MainViewModel
    @State private var isExpanded: Bool = false
    
    private let formatter = Formatter()
    
    var body: some View {
        Section {
            NavigationLink(
                destination: SearchView(mainViewModel: mainViewModel,
                                        mealType: mealType)
            ) {
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: iconName)
                            .foregroundColor(color)
                        Text(title)
                            .fontWeight(.medium)
                        Spacer()
                        Text(formatter.formattedValue(
                            calories,
                            unit: .empty,
                            alwaysRoundUp: true
                        ))
                        .fontWeight(.medium)
                    }
                    NutrientSummaryRow(
                        fats: fats,
                        carbs: carbohydrates,
                        proteins: proteins,
                        formatter: formatter
                    )
                }
                .padding(.vertical, 5)
                .padding(.trailing, 5)
            }
            
            if isExpanded {
                ForEach(foodItems) { item in
                    FoodItemRow(
                        mealItem: item,
                        searchViewModel: SearchViewModel(),
                        mainViewModel: mainViewModel,
                        mealType: mealType
                    )
                }
            }
            
            ShowHideButtonView(isExpanded: isExpanded) {
                isExpanded.toggle()
            }
        }
    }
}
