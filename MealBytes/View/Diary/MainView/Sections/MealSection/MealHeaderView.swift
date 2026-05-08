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
    let calories: Double
    let fat: Double
    let protein: Double
    let carbohydrate: Double
    @Binding var selectedMealItemForMove: MealItem?
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            Button {
                mainViewModel.navigateToSearch(for: mealType)
            } label: {
                HStack(spacing: 10) {
                    VStack(spacing: 15) {
                        HStack {
                            MealTypeLabel(
                                mealType: mealType,
                                title: title,
                                isHeader: true
                            )
                            
                            if mainViewModel
                                .hasMealItemsForMealType(
                                    for: mealType,
                                    on: mainViewModel.date
                                ) {
                                Text(mainViewModel.formattedCalories(calories))
                                    .layoutPriority(1)
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.primary)
                            }
                        }
                        .lineLimit(1)
                        
                        if mainViewModel
                            .hasMealItemsForMealType(
                                for: mealType,
                                on: mainViewModel.date
                            ) {
                            NutrientSummaryRow(
                                fat: fat,
                                carbohydrate: carbohydrate,
                                protein: protein,
                                calories: calories,
                                mainViewModel: mainViewModel
                            )
                        }
                    }
                    
                    Image(systemName: "plus")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(.accent)
                        .symbolColorRenderingMode(.gradient)
                }
            }
            .transaction { $0.animation = nil }
            .contextMenu {
                Button {
                    mainViewModel.navigateToSearch(for: mealType)
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                }
                
                if !filteredItems.isEmpty {
                    ShowHideButtonView(
                        isExpanded: Binding(
                            get: {
                                mainViewModel
                                    .expandedSections[mealType] ?? false
                            },
                            set: {
                                mainViewModel
                                    .expandedSections[mealType] = $0
                            }
                        ),
                        context: true
                    )
                }
            } preview: {
                Button {
                    mainViewModel.navigateToSearch(for: mealType)
                } label: {
                    if let searchViewModel = mainViewModel
                        .searchViewModel as? SearchViewModel {
                        SearchView(
                            searchViewModel: searchViewModel,
                            mealType: mealType
                        )
                    }
                }
            }
            
            if mainViewModel.expandedSections[mealType] == true {
                ForEach(filteredItems, id: \.id) { item in
                    FoodItemRow(
                        mealItem: item,
                        mealType: mealType,
                        mainViewModel: mainViewModel
                    )
                    .swipeActions(allowsFullSwipe: false) {
                        Button {
                            mainViewModel.deleteMealItemMainView(
                                with: item.id,
                                for: mealType
                            )
                            mainViewModel.uniqueId = UUID()
                        } label: {
                            Image(systemName: "trash")
                        }
                        .tint(.customRedSwipe)
                        
                        Button {
                            selectedMealItemForMove = item
                        } label: {
                            Image(systemName: "fork.knife")
                        }
                        .tint(.customGreenSwipe)
                    }
                }
            }
            if !filteredItems.isEmpty {
                ShowHideButtonView(
                    isExpanded: Binding(
                        get: {
                            mainViewModel
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
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
    }
    
    private var filteredItems: [MealItem] {
        mainViewModel.filteredMealItems(for: mealType, on: mainViewModel.date)
    }
    
    private func mealTypeLabel(
        for mealType: MealType,
        title: String? = nil,
        isHeader: Bool = false
    ) -> some View {
        Label {
            Text(title ?? mealType.rawValue)
                .foregroundStyle(Color.primary)
                .fontWeight(isHeader ? .medium : nil)
        } icon: {
            Image(systemName: mealType.iconName)
                .font(isHeader ? .title3 : nil)
                .foregroundStyle(
                    mealType.foregroundStyle.0,
                    mealType.foregroundStyle.1
                )
                .symbolRenderingMode(
                    mealType.renderingMode
                )
                .symbolColorRenderingMode(.gradient)
        }
        .labelIconToTitleSpacing(15)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    PreviewContentView.contentView
}
