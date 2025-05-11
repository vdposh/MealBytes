//
//  SearchView.swift
//  MealBytes
//
//  Created by Porshe on 04/03/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var mealType: MealType
    @ObservedObject var searchViewModel: SearchViewModel
    
    init(searchViewModel: SearchViewModel,
         mealType: MealType) {
        self.searchViewModel = searchViewModel
        self._mealType = State(initialValue: mealType)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if searchViewModel.isLoading {
                    LoadingView()
                } else if let error = searchViewModel.appError {
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
                                            navigationTitle:
                                                "Add to \(mealType.rawValue)",
                                            food: food,
                                            searchViewModel: searchViewModel,
                                            mainViewModel:
                                                searchViewModel.mainViewModel,
                                            mealType: mealType,
                                            amount: "",
                                            measurementDescription: "",
                                            showAddButton: true,
                                            showSaveRemoveButton: false,
                                            showMealTypeButton: false
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
                                                .handleBookmarkAction(for: food)
                                        },
                                        isFilled: searchViewModel
                                            .isBookmarkedSearchView(food),
                                        width: 45, height: 24
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
                                contentUnavailableView(for: .noBookmarks) { }
                            } else {
                                EmptyView()
                            }
                        }
                    )
                }
            }
            .navigationBarTitle("Search", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Button {
                        searchViewModel.showMealType = true
                    } label: {
                        HStack {
                            Image(systemName: mealType.iconName)
                                .font(.system(size: 13))
                                .frame(width: 15, height: 5)
                                .foregroundColor(mealType.color)
                            Text(mealType.rawValue)
                                .font(.headline)
                        }
                    }
                    .confirmationDialog(
                        "Choose a Meal",
                        isPresented: $searchViewModel.showMealType,
                        titleVisibility: .visible
                    ) {
                        ForEach(MealType.allCases, id: \.self) { meal in
                            Button {
                                mealType = meal
                            } label: {
                                Text(meal.rawValue)
                            }
                        }
                    }
                }
            }
            .confirmationDialog(
                searchViewModel.bookmarkTitle,
                isPresented: $searchViewModel.showBookmarkDialog,
                titleVisibility: .visible
            ) {
                Button("Remove bookmark", role: .destructive) {
                    searchViewModel.confirmRemoveBookmark()
                }
            }
            .searchable(
                text: $searchViewModel.query,
                prompt: "Enter a food name"
            )
        }
        .scrollDismissesKeyboard(.immediately)
    }
    
    @ViewBuilder
    private func pageButton(direction:
                            SearchViewModel.PageDirection) -> some View {
        if searchViewModel.canLoadPage(direction: direction) {
            Button {
                searchViewModel.loadPage(direction: direction)
            } label: {
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
    ContentView(
        loginViewModel: LoginViewModel(),
        mainViewModel: MainViewModel()
    )
}
