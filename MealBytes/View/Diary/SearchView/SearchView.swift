//
//  SearchView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var mealType: MealType
    @State private var selectedFood: Food?
    @State private var showFoodView = false
    
    @ObservedObject var searchViewModel: SearchViewModel
    
    init(searchViewModel: SearchViewModel,
         mealType: MealType) {
        self.searchViewModel = searchViewModel
        self._mealType = State(initialValue: mealType)
    }
    
    var body: some View {
        VStack {
            if searchViewModel.isLoading {
                LoadingView()
            } else if let error = searchViewModel.appError {
                contentUnavailableView(for: error, mealType: mealType) {
                    searchViewModel.queueSearch(searchViewModel.query)
                }
            } else {
                List {
                    ForEach(searchViewModel.foods,
                            id: \.searchFoodId) { food in
                        HStack {
                            Button {
                                selectedFood = food
                                showFoodView = true
                            } label: {
                                FoodDetailView(food: food)
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                            }
                            .padding(.vertical, 1)
                            .onChange(of: showFoodView) {
                                selectedFood = selectedFood
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
                .ignoresSafeArea(.keyboard)
                .background {
                    if searchViewModel.foods.isEmpty {
                        contentUnavailableView(
                            for: .noBookmarks,
                            mealType: mealType
                        ) { }
                    }
                }
                .listStyle(.plain)
                .scrollDismissesKeyboard(.immediately)
            }
        }
        .navigationBarTitle(
            searchViewModel.mainViewModel.formattedDate(isAbbreviated: true),
            displayMode: .large
        )
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
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
                            .foregroundStyle(.customGreen)
                    }
                }
                .confirmationDialog(
                    "Select a Meal Type",
                    isPresented: $searchViewModel.showMealType,
                    titleVisibility: .visible
                ) {
                    ForEach(MealType.allCases, id: \.self) { meal in
                        Button {
                            if searchViewModel.mealSwitch(to: meal) {
                                mealType = meal
                                Task {
                                    await searchViewModel
                                        .loadBookmarksSearchView(for: meal)
                                }
                            }
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
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Enter a food name"
        )
        .sheet(isPresented: $showFoodView) {
            if let food = selectedFood {
                NavigationStack {
                    FoodView(
                        navigationTitle: "Add to \(mealType.rawValue)",
                        food: food,
                        searchViewModel: searchViewModel,
                        mainViewModel: searchViewModel.mainViewModel,
                        mealType: mealType,
                        amount: "",
                        measurementDescription: "",
                        showAddButton: true,
                        showSaveRemoveButton: false,
                        showMealTypeButton: false
                    )
                }
                .interactiveDismissDisabled(true)
                .presentationCornerRadius(16)
            }
        }
    }
    
    @ViewBuilder
    private func pageButton(
        direction:
        SearchViewModel.PageDirection
    ) -> some View {
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
    PreviewContentView.contentView
}
