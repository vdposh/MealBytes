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
            foodItemContent
        } header: {
            header
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
            } else {
                VStack(alignment: .leading, spacing: 2.5) {
                    Text(mainViewModel.entryCountText(for: mealType))
                        .fontWeight(.medium)
                        .foregroundStyle(Color.primary)
                    
                    Text(mainViewModel.formatFoodList(for: mealType))
                        .font(.callout)
                        .foregroundStyle(Color.secondary)
                        .lineLimit(2)
                        .truncationMode(.head)
                }
            }
        }
        
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
                .swipeActions {
                    Button(role: .destructive) {
                        mainViewModel
                            .deleteMealItemMainView(
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
        if !mainViewModel.filteredItems(for: mealType).isEmpty {
            Button {
                withAnimation {
                    mainViewModel.expandedSections[mealType]?.toggle()
                }
            } label: {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        MealTypeText(
                            mealType: mealType,
                            title: title,
                            font: .title3,
                            fontWeight: .medium
                        )
                        
                        if mainViewModel.hasItems(for: mealType) {
                            let nutrients = mainViewModel.totalNutrients(
                                for: mealType
                            )
                            
                            NutrientSummaryRow(
                                mainViewModel: mainViewModel,
                                calories: calories,
                                fat: nutrients.fat,
                                carbs: nutrients.carbs,
                                protein: nutrients.protein
                            )
                        }
                    }
                    
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
//                    Image(systemName: "plus")
//                        .imageScale(.large)
//                        .fontWeight(.bold)
//                        .foregroundStyle(.accent)
//                        .padding(10)
//                        .glassEffect(.regular.interactive())
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(ButtonStyleInvisible())
        } else {
            MealTypeText(
                mealType: mealType,
                title: title,
                font: .title3,
                fontWeight: .medium
            )
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
