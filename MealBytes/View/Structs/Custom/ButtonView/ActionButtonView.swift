//
//  ActionButtonView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/03/2025.
//

import SwiftUI

struct ActionButtonView: View {
    let title: String
    let action: () -> Void
    var color: Color = .accent
    var isEnabled: Bool = true
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .font(.headline)
                .lineLimit(1)
                .cornerRadius(12)
        }
        .accentColor(color.opacity(isEnabled ? 1 : 0.6))
        .disabled(!isEnabled)
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
