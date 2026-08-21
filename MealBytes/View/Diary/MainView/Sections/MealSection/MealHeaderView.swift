//
//  MealHeaderView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 16/03/2025.
//

import SwiftUI

struct MealHeaderView: View {
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
        let uniqueFoodNames = items.map { $0.foodName }.uniqueOrdered()
        
        return formatter.format(foodNames: uniqueFoodNames)
    }
    
    var body: some View {
        Section {
            addFood
            foodItemsList
        } header: {
            headerContent
        }
        .transaction { $0.animation = nil }
        .alert(
            isPresented: $mainViewModel.showClearMealTypeAlert,
            content: {
                mainViewModel.clearMealTypeAlert()
            }
        )
    }
    
    // MARK: - Add Food
    @ViewBuilder
    private var addFood: some View {
        let isExpanded = mainViewModel.isExpanded(for: mealType)
        let hasItems = mainViewModel.hasItems(for: mealType)
        
        Button {
            if isExpanded {
                mainViewModel.navigateToSearch(for: mealType)
            } else {
                withAnimation {
                    mainViewModel.expandedSections[mealType]?.toggle()
                }
            }
        } label: {
            if isExpanded || !hasItems {
                addText
            } else {
                collapsedContent
            }
        }
        .listRowInsets(.trailing, 0)
    }
    
    private var addText: some View {
        Text("Add Food")
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(alignment: .trailing) {
                if mainViewModel.hasItems(for: mealType) {
                    Menu {
                        Button(role: .destructive) {
                            mainViewModel.mealTypeToClear = mealType
                            mainViewModel.showClearMealTypeAlert = true
                        } label: {
                            Label("Delete All", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .imageScale(.medium)
                            .foregroundStyle(Color.secondary)
                            .padding()
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
    }
    
    private var collapsedContent: some View {
        VStack(alignment: .leading) {
            Text(mainViewModel.entryCountText(for: mealType))
                .fontWeight(.semibold)
                .foregroundStyle(Color.primary)
            
            Text(formattedFoodList)
                .foregroundStyle(Color.secondary)
        }
        .font(.subheadline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.trailing)
    }
    
    // MARK: - Food Items
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
                .swipeActions {
                    Button(role: .destructive) {
                        mainViewModel.deleteMealItemMainView(
                            with: item.id,
                            for: mealType
                        )
                    }
                }
            }
        }
    }
    
    // MARK: - Header
    @ViewBuilder
    private var headerContent: some View {
        HeaderButtonView(
            mealType: mealType,
            title: title,
            calories: calories,
            fat: fat,
            carbs: carbohydrate,
            protein: protein,
            hasItems: mainViewModel.hasItems(for: mealType),
            isExpanded: mainViewModel.isExpanded(for: mealType),
            showNutrients: true
        ) {
            mainViewModel.expandedSections[mealType]?.toggle()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
