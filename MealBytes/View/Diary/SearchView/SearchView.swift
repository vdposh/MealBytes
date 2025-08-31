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
    
    @ObservedObject var searchViewModel: SearchViewModel
    
    init(
        searchViewModel: SearchViewModel,
        mealType: MealType
    ) {
        self.searchViewModel = searchViewModel
        self._mealType = State(initialValue: mealType)
    }
    
    var body: some View {
        NavigationStack {
            contentBody
                .navigationBarTitle("Search", displayMode: .large)
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
                                    .foregroundStyle(.accent)
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
                                                .loadBookmarksSearchView(
                                                    for: meal
                                                )
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
                        Task {
                            await searchViewModel.confirmRemoveBookmark()
                        }
                    }
                }
                .searchable(
                    text: $searchViewModel.query,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Enter a food name"
                )
        }
    }
    
    @ViewBuilder
    private var contentBody: some View {
        if searchViewModel.isLoading {
            LoadingView()
        } else if let error = searchViewModel.appError {
            contentUnavailableView(for: error, mealType: mealType) {
                searchViewModel.performSearch(searchViewModel.query)
            }
        } else {
            List {
                ForEach(searchViewModel.foods, id: \.searchFoodId) { food in
                    foodRow(for: food)
                }
                pageButton(direction: .next)
                pageButton(direction: .previous)
            }
            .listStyle(.plain)
            .ignoresSafeArea(.keyboard)
            .scrollDismissesKeyboard(.immediately)
            .background {
                if searchViewModel.foods.isEmpty {
                    contentUnavailableView(
                        for: .noBookmarks,
                        mealType: mealType
                    ) { }
                }
            }
        }
    }
    
    @ViewBuilder
    private func foodRow(for food: Food) -> some View {
        ZStack {
            Button {
                selectedFood = food
            } label: {
                HStack {
                    FoodDetailView(food: food)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding(.vertical, 1)
                    
                    BookmarkButtonView(
                        action: {
                            Task {
                                await searchViewModel.handleBookmarkAction(
                                    for: food
                                )
                            }
                        },
                        isFilled: searchViewModel.isBookmarkedSearchView(food),
                        width: 45,
                        height: 24
                    )
                }
            }
            NavigationLink(
                destination: FoodView(
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
            ) {
                EmptyView()
            }
            .opacity(0)
        }
    }
    
    @ViewBuilder
    private func pageButton(
        direction: SearchViewModel.PageDirection
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
            .foregroundStyle(.accent)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    PreviewContentView.contentView
}
