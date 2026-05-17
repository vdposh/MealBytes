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
                        }
                        .lineLimit(1)
                        
                        if mainViewModel
                            .hasMealItemsForMealType(
                                for: mealType,
                                on: mainViewModel.date
                            ) {
                            let nutrients = mainViewModel
                                .totalNutrients(for: mealType)
                            
                            NutrientSummaryRow(
                                fat: nutrients.fat,
                                carbs: nutrients.carbs,
                                protein: nutrients.protein,
                                calories: calories,
                                mainViewModel: mainViewModel
                            )
                        }
                    }
                    
                    if mainViewModel
                        .hasMealItemsForMealType(
                            for: mealType,
                            on: mainViewModel.date
                        ) {
                        if mainViewModel.canDisplayIntake() {
                            Gauge(value: mainViewModel
                                .progressValue(for: mealType)) {
                                    Text(
                                        mainViewModel
                                            .totalIntakePercentage(
                                                for: mealType
                                            )
                                    )
                                    .tint(.primary)
                                } currentValueLabel: {
                                    Text(
                                        mainViewModel
                                            .totalCalories(
                                                for: mealType
                                            ).asCalories()
                                    )
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .tint(.primary)
                                }
                                .gaugeStyle(.accessoryCircular)
                                .tint(Gradient.progressGradientGreen)
                        } else {
                            if mainViewModel
                                .hasMealItemsForMealType(
                                    for: mealType,
                                    on: mainViewModel.date
                                ) {
                                Text(
                                    mainViewModel
                                        .totalCalories(
                                            for: mealType
                                        ).asWhole()
                                )
                                .layoutPriority(1)
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.primary)
                            }
                        }
                    } else {
                        Image(systemName: "plus")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.accent)
                            .symbolColorRenderingMode(.gradient)
                    }
                }
            }
            .transaction { $0.animation = nil }
            .contextMenu {
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
}

#Preview {
    PreviewContentView.contentView
}
