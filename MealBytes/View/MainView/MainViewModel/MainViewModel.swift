//
//  MainViewModel.swift
//  MealBytes
//
//  Created by Porshe on 14/03/2025.
//

import SwiftUI
import Combine

final class MainViewModel: ObservableObject {
    @Published var selectedDate = Date()
    @Published var foodItems: [MealItem] = []

    func addFoodItem(_ item: MealItem) {
        foodItems.append(item)
    }
}

#Preview {
    MainView()
}
