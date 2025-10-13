//
//  MealHeaderView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct MealHeaderView: View {
    @Binding var selectedMealType: MealType?
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
            Button {
                selectedMealType = mealType
                mainViewModel.searchViewModel.loadingBookmarks()
                Task {
                    await mainViewModel.searchViewModel
                        .loadBookmarksSearchView(for: mealType)
                }
            } label: {
                HStack {
                    VStack(spacing: 15) {
                        HStack {
                            Image(systemName: iconName)
                                .frame(width: 25)
                                .foregroundStyle(color)
                            Text(title)
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                                .foregroundStyle(Color.primary)
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                            .labelIconToTitleSpacing(10)
                            .frame(maxWidth: .infinity,alignment: .leading
                            )
                            Text(mainViewModel.formattedCalories(calories))
                                .lineLimit(1)
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.primary)
                        }
                        
                        NutrientSummaryRow(
                            fat: fat,
                            carbohydrate: carbohydrate,
                            protein: protein,
                            calories: calories,
                            mainViewModel: mainViewModel
                        )
                    }
                    .padding(.trailing, 4)
                    
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                }
            }
            .animation(nil, value: UUID())
            
            if mainViewModel.expandedSections[mealType] == true {
                let foodItems = mainViewModel.filteredMealItems(
                    for: mealType,
                    on: mainViewModel.date
                )
                
                if !foodItems.isEmpty {
                    ForEach(foodItems, id: \.id) { item in
                        FoodItemRow(
                            selectedMealItem: $mainViewModel.selectedMealItem,
                            mealItem: item,
                            mealType: mealType,
                            mainViewModel: mainViewModel
                        )
                        .swipeActions(allowsFullSwipe: false) {
                            Button(
                                role: mainViewModel
                                    .deletionButtonRole(for: mealType)
                            ) {
                                mainViewModel.deleteMealItemMainView(
                                    with: item.id,
                                    for: mealType
                                )
                            } label: {
                                Label("Remove", systemImage: "trash")
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
    PreviewContentView.contentView
}
