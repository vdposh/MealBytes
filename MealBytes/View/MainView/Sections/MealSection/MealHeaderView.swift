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
    @State private var isFoodViewPresented: Bool = false
    
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
                            Text(mainViewModel.formattedCalories(calories))
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                        }
                        NutrientSummaryRow(
                            fats: fats,
                            carbs: carbohydrates,
                            proteins: proteins,
                            mainViewModel: mainViewModel
                        )
                    }
                    .padding(.vertical, 5)
                    .padding(.trailing, 5)
                    
                    Text("+")
                        .font(.title)
                        .foregroundColor(.customGreen)
                }
            }
            .sheet(isPresented: $isPresentingSheet) {
                SearchView(
                    isPresented: $isPresentingSheet,
                    searchViewModel: mainViewModel.searchViewModel,
                    mainViewModel: mainViewModel,
                    mealType: mealType
                )
            }
            
            if isExpanded {
                ForEach(foodItems) { item in
                    FoodItemRow(
                        mealItem: item,
                        mainViewModel: mainViewModel,
                        mealType: mealType,
                        isDismissed: $isFoodViewPresented
                    )
                }
            }
            
            ShowHideButtonView(isExpanded: $isExpanded)
        }
    }
}

#Preview {
    MainView()
}
