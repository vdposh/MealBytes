//
//  SearchView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @State private var currentPage: Int = 0
    
    var onAddFoodItem: (MealItem) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoading {
                    LoadingView()
                } else if viewModel.errorMessage != nil {
                    ContentUnavailableView.search(text: viewModel.query)
                } else {
                    List {
                        ForEach(viewModel.foods, id: \.searchFoodId) { food in
                            HStack {
                                NavigationLink(
                                    destination: FoodView(
                                        food: food,
                                        searchViewModel: viewModel,
                                        onAddFoodItem: onAddFoodItem
                                    )
                                ) {
                                    FoodDetailView(food: food,
                                                   viewModel: viewModel)
                                }
                                
                                BookmarkButtonView(
                                    action: {
                                        viewModel.toggleBookmark(for: food)
                                    },
                                    isFilled: viewModel.isBookmarked(food)
                                )
                            }
                        }
                        
                        pageButton(direction: .next)
                        pageButton(direction: .previous)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationBarTitle("Add to Diary", displayMode: .inline)
            .searchable(text: $viewModel.query)
        }
        .accentColor(.customGreen)
        .scrollDismissesKeyboard(.immediately)
    }
    
    @ViewBuilder
    private func pageButton(direction:
                            SearchViewModel.PageDirection) -> some View {
        if viewModel.canLoadPage(direction: direction) {
            Button(action: {
                viewModel.loadPage(direction: direction)
            }) {
                switch direction {
                case .next:
                    Text("> Next Page")
                        .foregroundColor(.customGreen)
                case .previous:
                    Text("< Previous Page")
                        .foregroundColor(.customGreen)
                }
            }
        } else {
            EmptyView()
        }
    }
}

#Preview {
    SearchView(
        onAddFoodItem: { _ in }
    )
}
