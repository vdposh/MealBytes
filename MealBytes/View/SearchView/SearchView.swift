//
//  SearchView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.errorMessage != nil {
                    ContentUnavailableView.search(text: "\(viewModel.query)")
                } else {
                    List(viewModel.foods, id: \.food_id) { food in
                        NavigationLink(destination: FoodView(food: food)) {
                            Text(food.food_name)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Search Products")
            .searchable(text: $viewModel.query)
        }
        .accentColor(.customGreen)
    }
}

#Preview {
    SearchView()
}
