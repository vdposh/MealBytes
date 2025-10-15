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
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            Button {
                mainViewModel.selectedMealType = mealType
                mainViewModel.searchViewModel.loadingBookmarks()
                Task {
                    await mainViewModel.searchViewModel
                        .loadBookmarksSearchView(for: mealType)
                }
            } label: {
                HStack(spacing: 10) {
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
                    
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                        .foregroundStyle(.accent)
                }
            }
            .animation(nil, value: UUID())
            
            let filteredItems = mainViewModel.filteredMealItems(
                for: mealType,
                on: mainViewModel.date
            )
            
            if mainViewModel.expandedSections[mealType] == true {
                if !filteredItems.isEmpty {
                    ForEach(filteredItems, id: \.id) { item in
                        FoodItemRow(
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
            
            if !filteredItems.isEmpty {
                ShowHideButtonView(
                    isExpanded: Binding(
                        get: { mainViewModel
                            .expandedSections[mealType] ?? false
                        },
                        set: {
                            mainViewModel
                                .expandedSections[mealType] = $0
                        }
                    )
                )
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
