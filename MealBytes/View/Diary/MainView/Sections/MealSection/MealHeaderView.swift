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
    @ObservedObject var mainViewModel: MainViewModel
    
    var body: some View {
        Section {
            Button {
                mainViewModel.navigateToSearch(for: mealType)
            } label: {
                HStack(spacing: 10) {
                    VStack(spacing: 15) {
                        HStack {
                            Label {
                                Text(title)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.primary)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                            } icon: {
                                Image(systemName: mealType.iconName)
                                    .font(.title3)
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
                    Label("Go to \(title)", systemImage: mealType.iconName)
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
                        .tint(.red)
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
}

#Preview {
    PreviewContentView.contentView
}
