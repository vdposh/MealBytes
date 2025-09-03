//
//  ServingButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/03/2025.
//

import SwiftUI

struct ServingButtonView: View {
    @Binding var showActionSheet: Bool
    let title: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            HStack {
                Text(description)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                Image(systemName: "chevron.down")
                    .resizable()
                    .frame(width: 10, height: 6)
            }
            .frame(height: 35)
            .overlay(
                FieldUnderlineView(isFocused: false),
                alignment: .bottom
            )
        }
        .contentShape(Rectangle())
        .overlay(
            Button(action: {
                action()
            }) {
                Color.clear
            }
        )
    }
}

#Preview {
    NavigationStack {
        FoodView(
            navigationTitle: "Add to Diary",
            food: Food(
                searchFoodId: 3092,
                searchFoodName: "Egg",
                searchFoodDescription: "1 cup"
            ),
            searchViewModel: SearchViewModel(mainViewModel: MainViewModel()),
            mainViewModel: MainViewModel(),
            mealType: .breakfast,
            amount: "1",
            measurementDescription: "Grams",
            showAddButton: false,
            showSaveRemoveButton: true,
            showMealTypeButton: true,
            originalMealItemId: UUID()
        )
    }
}

#Preview {
    PreviewContentView.contentView
}
