//
//  FoodDetailView.swift
//  MealBytes
//
//  Created by Porshe on 13/03/2025.
//

import SwiftUI

struct FoodDetailView: View {
    let food: Food
    
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(food.searchFoodName)
            if let parsedDescription = food.parsedDescription {
                Text(parsedDescription)
                    .foregroundColor(.customGreen)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel()
    )
}
