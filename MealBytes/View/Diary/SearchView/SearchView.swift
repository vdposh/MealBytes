//
//  SearchView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var currentPage: Int = 0
    @Binding private var isPresented: Bool
    private let mealType: MealType
    
    @ObservedObject private var searchViewModel: SearchViewModel
    
    init(isPresented: Binding<Bool>,
         searchViewModel: SearchViewModel,
         mealType: MealType) {
        self._isPresented = isPresented
        self.searchViewModel = searchViewModel
        self.mealType = mealType
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if searchViewModel.isLoading {
                    LoadingView()
                } else if let error = searchViewModel.errorMessage {
                    contentUnavailableView(for: error) {
                        searchViewModel.queueSearch(searchViewModel.query)
                    }
                } else {
                    List {
                        if !searchViewModel.foods.isEmpty {
                            ForEach(searchViewModel.foods,
                                    id: \.searchFoodId) { food in
                                HStack {
                                    NavigationLink(
                                        destination: FoodView(
                                            isDismissed: $isPresented,
                                            food: food,
                                            searchViewModel: searchViewModel,
                                            mainViewModel: searchViewModel
                                                .mainViewModel,
                                            mealType: mealType,
                                            amount: "",
                                            measurementDescription: "",
                                            showAddButton: true,
                                            showSaveRemoveButton: false,
                                            showCloseButton: true
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
                                                .toggleBookmarkSearchView(
                                                    for: food)
                                        },
                                        isFilled: searchViewModel
                                            .isBookmarkedSearchView(food),
                                        width: 45,
                                        height: 24
                                    )
                                }
                            }
                            pageButton(direction: .next)
                            pageButton(direction: .previous)
                        }
                    }
                    .listStyle(.plain)
                    .background(
                        Group {
                            if searchViewModel.foods.isEmpty {
                                contentUnavailableView(for: .noBookmarks,
                                                       query: "") { }
                            } else {
                                EmptyView()
                            }
                        }
                    )
                }
            }
            .navigationBarTitle("Search", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
            .searchable(
                text: $searchViewModel.query,
                prompt: "Enter a food name"
            )
            
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
                    HStack {
                        Image(systemName: "chevron.right")
                        Text("Next Page")
                    }
                case .previous:
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Previous Page")
                    }
                }
            }
            .foregroundColor(.customGreen)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    NavigationStack {
        SearchView(
            isPresented: .constant(true),
            searchViewModel: SearchViewModel(
                mainViewModel: MainViewModel()
            ),
            mealType: .breakfast
        )
    }
    .accentColor(.customGreen)
}
