//
//  SearchView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct SearchView: View {
    private var mainViewModel: MainViewModel
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var currentPage: Int = 0
    @Environment(\.dismiss) private var dismiss
    let mealType: MealType
    
    init(mainViewModel: MainViewModel,
         mealType: MealType) {
        self.mainViewModel = mainViewModel
        self.mealType = mealType
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if searchViewModel.isLoading {
                    LoadingView()
                } else if searchViewModel.errorMessage != nil {
                    ContentUnavailableView.search(text: searchViewModel.query)
                } else {
                    List {
                        ForEach(searchViewModel.foods, id: \.searchFoodId) {
                            food in
                            HStack {
                                NavigationLink(
                                    destination: FoodView(
                                        food: food,
                                        searchViewModel: searchViewModel,
                                        mainViewModel: mainViewModel,
                                        mealType: mealType,
                                        isFromSearchView: true,
                                        isFromFoodItemRow: false,
                                        amount: "",
                                        measurementDescription: ""
                                    )
                                ) {
                                    FoodDetailView(
                                        food: food,
                                        searchViewModel: searchViewModel
                                    )
                                }
                                
                                BookmarkButtonView(
                                    action: {
                                        searchViewModel
                                            .toggleBookmark(for: food)
                                    },
                                    isFilled: searchViewModel
                                        .isBookmarked(food)
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.customGreen)
                }
            }
            .searchable(text: $searchViewModel.query)
        }
        .accentColor(.customGreen)
        .scrollDismissesKeyboard(.immediately)
    }
    
    @ViewBuilder
    private func pageButton(direction:
                            SearchViewModel.PageDirection) -> some View {
        if searchViewModel.canLoadPage(direction: direction) {
            Button(action: {
                searchViewModel.loadPage(direction: direction)
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
        mainViewModel: MainViewModel(),
        mealType: .breakfast
    )
}
