//
//  FoodDetailView.swift
//  MealBytes
//
//  Created by Porshe on 13/03/2025.
//

import SwiftUI

struct FoodDetailView: View {
    let food: Food
    let viewModel: SearchViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(food.searchFoodName)
            if let parsedDescription = food.parsedDescription {
                Text(parsedDescription).foregroundColor(.gray)
            }
        }
    }
}
