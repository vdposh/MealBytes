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
    @State private var isPresentingSheet: Bool = false
    @State private var isExpanded: Bool = false
    
    private let formatter = Formatter()
    
    var body: some View {
        Section {
            Button(action: {
                isPresentingSheet = true
            }) {
                HStack {
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: iconName)
                                .foregroundColor(color)
                            Text(title)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                            Spacer()
                            Text(formatter.formattedValue(
                                calories,
                                unit: .empty,
                                alwaysRoundUp: true
                            ))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                        }
                        NutrientSummaryRow(
                            fats: fats,
                            carbs: carbohydrates,
                            proteins: proteins,
                            formatter: formatter
                        )
                    }
                    .padding(.vertical, 5)
                    .padding(.trailing, 1)
                    
                    Text("+")
                        .font(.title)
                        .foregroundColor(.customGreen)
                }
            }
            .sheet(isPresented: $isPresentingSheet) {
                SearchView(mainViewModel: mainViewModel,
                           mealType: mealType)
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

#Preview {
    MainView()
}
