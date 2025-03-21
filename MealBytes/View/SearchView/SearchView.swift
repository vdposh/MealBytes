//
//  SearchView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject private var searchViewModel: SearchViewModel
    @Binding private var isPresented: Bool
    @State private var currentPage: Int = 0
    private let mealType: MealType
    
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
                } else if let errorMessage = searchViewModel.errorMessage {
                    errorMessage.contentUnavailableView(query: "") {
                        searchViewModel.debounceSearch(searchViewModel.query)
                    }
                } else {
                    List {
                        if !searchViewModel.foods.isEmpty {
                            ForEach(searchViewModel.foods, id: \.searchFoodId) {
                                food in
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
                                                .toggleBookmarkSearchView(for: food)
                                        },
                                        isFilled: searchViewModel
                                            .isBookmarked(food),
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
                                noBookmarksView()
                            } else {
                                EmptyView()
                            }
                        }
                    )
                }
            }
            .navigationBarTitle("Search", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
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
    
    private func noBookmarksView() -> some View {
        ContentUnavailableView {
            Label {
                Text("No bookmarks yet")
            } icon: {
                Image("bookEmptyOpacity")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
        } description: {
            Text("Add your favorite dishes to bookmarks, and they'll appear here.")
        }
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
            searchViewModel: SearchViewModel(mainViewModel: MainViewModel()),
            mealType: .breakfast
        )
    }
    .accentColor(.customGreen)
}
