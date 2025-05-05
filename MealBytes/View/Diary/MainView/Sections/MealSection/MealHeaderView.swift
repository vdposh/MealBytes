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
    let fat: Double
    let protein: Double
    let carbohydrate: Double
    let foodItems: [MealItem]
    @State private var isPresentingSheet: Bool = false
    @State private var isFoodViewPresented: Bool = false
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            Button {
                mainViewModel.searchViewModel.query = ""
                isPresentingSheet = true
            } label: {
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
                                .lineLimit(1)
                                .font(.callout)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                        NutrientSummaryRow(
                            fat: fat,
                            carbohydrate: carbohydrate,
                            protein: protein,
                            calories: calories,
                            mainViewModel: mainViewModel
                        )
                    }
                    .padding(.vertical, 5)
                    .padding(.trailing, 5)
                    
                    Image(systemName: "plus")
                        .font(.headline)
                }
            }
            .fullScreenCover(isPresented: $isPresentingSheet) {
                SearchView(
                    isPresented: $isPresentingSheet,
                    searchViewModel: mainViewModel.searchViewModel,
                    mealType: mealType
                )
            }
            
            if mainViewModel.expandedSections[mealType] == true {
                let foodItems = mainViewModel.filteredMealItems(
                    for: mealType,
                    on: mainViewModel.date
                )
                
                if !foodItems.isEmpty {
                    ForEach(foodItems, id: \.id) { item in
                        FoodItemRow(
                            isDismissed: $isFoodViewPresented,
                            mealItem: item,
                            mealType: mealType,
                            mainViewModel: mainViewModel
                        )
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: mainViewModel.deletionButtonRole(
                                for: mealType
                            )) {
                                Task {
                                    mainViewModel.deleteMealItemMainView(
                                        with: item.id,
                                        for: mealType
                                    )
                                }
                                mainViewModel.uniqueID = UUID()
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    }
                }
            }
            
            if !foodItems.isEmpty {
                ShowHideButtonView(isExpanded: Binding(
                    get: { mainViewModel.expandedSections[mealType] ?? false },
                    set: { mainViewModel.expandedSections[mealType] = $0 }
                ))
            }
        }
    }
}

#Preview {
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel()
    )
}
