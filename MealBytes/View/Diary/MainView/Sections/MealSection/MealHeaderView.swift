//
//  MealHeaderView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct MealHeaderView: View {
    @Binding var selectedMealItemForMove: MealItem?
    @ObservedObject var mainViewModel: MainViewModel
    
    let mealType: MealType
    let title: String
    let calories: Double
    let fat: Double
    let protein: Double
    let carbohydrate: Double
    
    var body: some View {
        Section {
            headerContent
                .transaction { $0.animation = nil }
                .contextMenu {
                    contextMenuContent
                }
            foodItemContent
            showHideButton
        }
    }
    
    private var headerContent: some View {
        Button {
            mainViewModel.navigateToSearch(for: mealType)
        } label: {
            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 7.5) {
                    HStack {
                        MealTypeText(
                            mealType: mealType,
                            title: title,
                            isHeader: true
                        )
                        
                        if mainViewModel.hasItems(for: mealType) {
                            Text(
                                mainViewModel.totalCaloriesText(for: mealType)
                            )
                            .layoutPriority(1)
                            .font(.callout)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.primary)
                        }
                    }
                    
                    if mainViewModel.hasItems(for: mealType) {
                        let nutrients = mainViewModel.totalNutrients(
                            for: mealType
                        )
                        
                        HStack {
                            NutrientSummaryRow(
                                mainViewModel: mainViewModel,
                                fat: nutrients.fat,
                                carbs: nutrients.carbs,
                                protein: nutrients.protein,
                                calories: calories
                            )
                            
                            if mainViewModel.canDisplayIntake() {
                                Text(
                                    mainViewModel
                                        .intakePercentageText(for: mealType)
                                )
                                .font(.subheadline)
                                .foregroundStyle(Color.secondary)
                            }
                        }
                    }
                }
                
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.accent)
                    .symbolColorRenderingMode(.gradient)
            }
            .lineLimit(1)
        }
    }
    
    @ViewBuilder
    private var contextMenuContent: some View {
        if !mainViewModel.filteredItems(for: mealType).isEmpty {
            ShowHideButtonView(
                isExpanded: mainViewModel.isExpandedBinding(for: mealType),
                context: true,
                itemCount: mainViewModel.filteredItems(for: mealType).count
            )
        }
    }
    
    @ViewBuilder
    private var foodItemContent: some View {
        if mainViewModel.isExpanded(for: mealType) {
            ForEach(
                mainViewModel.filteredItems(for: mealType),
                id: \.id
            ) { item in
                FoodItemRow(
                    mealItem: item,
                    mealType: mealType,
                    mainViewModel: mainViewModel
                )
                .swipeActions(allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        mainViewModel.deleteMealItemMainView(
                            with: item.id,
                            for: mealType
                        )
                        mainViewModel.uniqueId = UUID()
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.customRed)
                    
                    Button {
                        selectedMealItemForMove = item
                    } label: {
                        Image(systemName: "fork.knife")
                    }
                    .tint(.accent)
                }
            }
        }
    }
    
    @ViewBuilder
    private var showHideButton: some View {
        if !mainViewModel.filteredItems(for: mealType).isEmpty {
            ShowHideButtonView(
                isExpanded: mainViewModel.isExpandedBinding(for: mealType),
                showCount: true,
                itemCount: mainViewModel.filteredItems(for: mealType).count
            )
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
