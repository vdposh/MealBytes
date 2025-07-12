//
//  MealHeaderView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
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
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            ZStack {
                Button {
                    Task {
                        await mainViewModel.searchViewModel
                            .loadBookmarksData(for: mealType)
                    }
                } label: {
                    HStack {
                        VStack(spacing: 15) {
                            HStack {
                                Image(systemName: iconName)
                                    .frame(width: 22)
                                    .foregroundColor(color)
                                Text(title)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                                Text(mainViewModel.formattedCalories(calories))
                                    .lineLimit(1)
                                    .font(.callout)
                                    .fontWeight(.medium)
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
                            .fontWeight(.bold)
                    }
                }
                .background(
                    NavigationLink(
                        destination: SearchView(
                            searchViewModel: mainViewModel.searchViewModel,
                            mealType: mealType
                        )
                    ) {
                        EmptyView()
                    }
                        .opacity(0)
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
    let loginViewModel = LoginViewModel()
    let mainViewModel = MainViewModel()
    let goalsViewModel = GoalsViewModel(mainViewModel: mainViewModel)

    ContentView(
        loginViewModel: loginViewModel,
        mainViewModel: mainViewModel,
        goalsViewModel: goalsViewModel
    )
    .environmentObject(ThemeManager())
}
