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
                                        searchViewModel: viewModel)) {
                                            VStack(alignment: .leading) {
                                                Text(food.searchFoodName)
                                                if let parsedDescription = food
                                                    .parsedDescription {
                                                    Text(parsedDescription)
                                                        .foregroundColor(.customGreen)
                                                }
                                            }
                                        }
                                
                                BookmarkButtonView(
                                    action: {
                                        viewModel.toggleBookmark(for: food)
                                    },
                                    isFilled: viewModel.isBookmarked(food)
                                )
                            }
                        }
                        
                        if !viewModel.foods.isEmpty {
                            if viewModel.foods.count ==
                                viewModel.maxResultsPerPage {
                                Button(action: {
                                    viewModel.loadNextPage()
                                }) {
                                    Text("> Next Page")
                                        .foregroundColor(.customGreen)
                                }
                            }
                            
                            if viewModel.currentPage > 0 {
                                Button(action: {
                                    viewModel.loadPreviousPage()
                                }) {
                                    Text("< Previous Page")
                                        .foregroundColor(.customGreen)
                                }
                            }
                        }
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
}

#Preview {
    SearchView()
}
