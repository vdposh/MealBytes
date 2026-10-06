//
//  FoodItemRow.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 14/03/2025.
//

import SwiftUI

struct FoodItemRow: View {
    let mealItem: MealItem
    let mealType: MealType
    let energyUnit: EnergyUnit
    let formattedText: String
    let onSelect: () -> Void
    let onMove: (MealType) -> Void
    let onDelete: () -> Void
    
    var body: some View {
        Button {
            onSelect()
        } label: {
            FoodItemView(
                foodName: mealItem.foodName,
                formattedText: formattedText,
                calories: energyUnit.fromKcal(fromKcal: mealItem.caloriesValue),
                fat: mealItem.fatValue,
                carbs: mealItem.carbsValue,
                protein: mealItem.proteinValue
            )
        }
        .contextMenu {
            foodItemContextMenu
        }
    }
    
    @ViewBuilder
    private var foodItemContextMenu: some View {
        Menu {
            Picker("Meal type", selection: Binding(
                get: { mealItem.mealType },
                set: { onMove($0) }
            )) {
                ForEach(MealType.allCases, id: \.self) { mealType in
                    Text(mealType.rawValue).tag(mealType)
                }
            }
        } label: {
            Label("Meal type", systemImage: "fork.knife")
        }
        
        Divider()
        
        Button(role: .destructive, action: onDelete) {
            Label("Delete", systemImage: "trash")
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
