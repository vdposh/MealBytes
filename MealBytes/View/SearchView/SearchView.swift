//
//  SearchView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct SearchView: View {
    @Binding private var isPresented: Bool
    @State private var currentPage: Int = 0
    private let mealType: MealType
    
    @ObservedObject private var searchViewModel: SearchViewModel
    private var mainViewModel: MainViewModel
    
    init(isPresented: Binding<Bool>,
         searchViewModel: SearchViewModel,
         mainViewModel: MainViewModel,
         mealType: MealType) {
        self._isPresented = isPresented
        self.searchViewModel = searchViewModel
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
                                        isDismissed: $isPresented,
                                        food: food,
                                        searchViewModel: searchViewModel,
                                        mainViewModel: mainViewModel,
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
                    Button("Close") {
                        isPresented = false
                    }
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
        isPresented: .constant(true),
        searchViewModel: SearchViewModel(),
        mainViewModel: MainViewModel(),
        mealType: .breakfast
    )
}
