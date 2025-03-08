//
//  SearchView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Combine

// ЧЕРНОВИК для перехода в FoodView
struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.foods, id: \.food_id) { food in
                    NavigationLink(destination: FoodView(food: food)) {
                        Text(food.food_name)
                    }
                }
                .listStyle(.plain)
                .searchable(text: $viewModel.query)
                .onChange(of: viewModel.query) {_, newValue in
                    viewModel.searchFoods(newValue)
                }
            }
            .navigationTitle("Search Products")
        }
        .accentColor(.customGreen)
        .alert(item: $viewModel.errorMessage) { error in
            Alert(
                title: Text(error.title),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
