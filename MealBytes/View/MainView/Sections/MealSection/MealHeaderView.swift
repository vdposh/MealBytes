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
    @State private var isFoodViewPresented: Bool = false
    
    var body: some View {
        Section {
            Button(action: {
                mainViewModel.searchViewModel.query = ""
                isPresentingSheet = true
            }) {
                HStack {
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: iconName)
                                .foregroundColor(color)
                            Text(title)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(mainViewModel.formattedCalories(calories))
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
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
            
            if mainViewModel.expandedSections[mealType] == true {
                ForEach(foodItems) { item in
                    FoodItemRow(
                        mealItem: item,
                        mainViewModel: mainViewModel,
                        mealType: mealType,
                        isDismissed: $isFoodViewPresented
                    )
                    .swipeActions {
                        Button(role: .destructive) {
                            mainViewModel.deleteMealItem(with: item.id,
                                                         for: mealType)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            
            ShowHideButtonView(isExpanded: Binding(
                get: { mainViewModel.expandedSections[mealType] ?? false },
                set: { mainViewModel.expandedSections[mealType] = $0 }
            ))
        }
    }
}
