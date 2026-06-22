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
    
    private let formatter = FoodListFormatter()
    
    private var formattedFoodList: String {
        let items = mainViewModel.filteredItems(for: mealType)
        let foodNames = items.map { $0.foodName }
        return formatter.format(foodNames: foodNames)
    }
    
    var body: some View {
        Section {
            foodItemsList
            foodItemContent
        } header: {
            header
        } footer: {
            nutrientSummaryRow
        }
        .transaction { $0.animation = nil }
    }
    
    @ViewBuilder
    private var foodItemContent: some View {
        Button {
            if mainViewModel.isExpanded(for: mealType) {
                mainViewModel.navigateToSearch(for: mealType)
            } else {
                withAnimation {
                    mainViewModel.expandedSections[mealType]?.toggle()
                }
            }
        } label: {
            if mainViewModel.isExpanded(for: mealType) {
                Text("Add Food")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.trailing, 50)
                    .overlay(alignment: .trailing) {
                        Button {
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .ellipsisMenuStyle()
                        }
                        .buttonStyle(.plain)
                    }
            } else {
                VStack(alignment: .leading, spacing: 2.5) {
                    Text(mainViewModel.entryCountText(for: mealType))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.primary)
                    
                    Text(formattedFoodList)
                        .foregroundStyle(Color.secondary)
                }
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.trailing)
            }
        }
        .listRowInsets(.trailing, 0)
    }
    
    @ViewBuilder
    private var foodItemsList: some View {
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
    private var header: some View {
        let mealTypeTitle = MealTypeText(
            mealType: mealType,
            title: title,
            font: .title3,
            fontWeight: .medium
        )
        
        if mainViewModel.hasItems(for: mealType) {
            Button {
                withAnimation {
                    mainViewModel.expandedSections[mealType]?.toggle()
                }
            } label: {
                HStack {
                    mealTypeTitle
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundStyle(.accent)
                        .rotationEffect(
                            .degrees(
                                mainViewModel
                                    .isExpanded(for: mealType) ? 90 : 0
                            )
                        )
                        .animation(
                            .default,
                            value: mainViewModel.isExpanded(for: mealType)
                        )
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .contentShape(Rectangle())
            }
            .listRowInsets(.all, 0)
            .buttonStyle(ButtonStyleInvisible())
        } else {
            mealTypeTitle
        }
    }
    
    @ViewBuilder
    private var nutrientSummaryRow: some View {
        if mainViewModel.hasItems(for: mealType) {
            let nutrients = mainViewModel.totalNutrients(for: mealType)
            
            NutrientSummaryRow(
                mainViewModel: mainViewModel,
                calories: calories,
                fat: nutrients.fat,
                carbs: nutrients.carbs,
                protein: nutrients.protein
            )
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
