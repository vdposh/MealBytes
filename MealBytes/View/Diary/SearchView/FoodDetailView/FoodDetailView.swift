//
//  FoodDetailView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 13/03/2025.
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
    let loginViewModel = LoginViewModel()
    let mainViewModel = MainViewModel()
    let goalsViewModel = GoalsViewModel(mainViewModel: mainViewModel)
    
    ContentView(
        loginViewModel: loginViewModel,
        mainViewModel: mainViewModel,
        goalsViewModel: goalsViewModel
    )
    .environmentObject(ThemeManager())
}
