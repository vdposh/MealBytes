//
//  FieldTitleView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 08/08/2025.
//

import SwiftUI

struct FieldTitleView: View {
    let title: String
    let showStar: Bool
    let titleColor: Color
    let isFocused: Binding<Bool>
    
    var body: some View {
        Button {
            isFocused.wrappedValue = true
        } label: {
            HStack(spacing: 0) {
                Text(title)
                    .font(.caption)
                    .accentColor(titleColor)
                if showStar {
                    Text("*")
                        .accentColor(.customRed)
                }
            }
            .frame(height: 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .overlay(
                Button(action: {
                    isFocused.wrappedValue = true
                }) {
                    Color.clear
                }
            )
        }
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
