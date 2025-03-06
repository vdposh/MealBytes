//
//  SearchView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI
import Combine
//ЧЕРНОВИК для перехода в FoodView
struct SearchView: View {
    @State private var foods: [Food] = []
    @State private var query: String = ""
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    
    var body: some View {
        NavigationStack {
            VStack {
                List(foods, id: \.food_id) { food in
                    NavigationLink(destination: FoodView(food: food)) {
                        Text(food.food_name)
                    }
                }
                .listStyle(.plain)
                .searchable(text: $query)
                .onChange(of: query) { _, newValue in
                    searchFoods(newValue) }
            }
            .navigationTitle("Search Products")
        }
        .accentColor(.green)
    }
    
    private func searchFoods(_ query: String) {
        if query.isEmpty {
            foods = []
            return
        }
        
        Task {
            do {
                let result = try await networkManager.searchFoods(query: query)
                self.foods = result
            } catch { }
        }
    }
}

struct IdentifiableString: Identifiable {
    let id = UUID()
    let value: String
}

#Preview {
    SearchView()
}
