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
            SearchViewContentBody
                .navigationBarTitle("Search")
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    SearchViewToolbar
                }
                .searchable(
                    text: $searchViewModel.query,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: "Search for food"
                )
                .onChange(of: mealType) {
                    if searchViewModel.mealSwitch(to: mealType) {
                        Task {
                            await searchViewModel
                                .loadBookmarksSearchView(for: mealType)
                        }
                    }
                }
                .task {
                    await searchViewModel
                        .loadBookmarksSearchView(for: mealType)
                }
        }
    }
    
    @ViewBuilder
    private var SearchViewContentBody: some View {
        switch searchViewModel.contentState {
        case .loading:
            LoadingView()
        case .error(let error):
            contentUnavailableView(for: error, mealType: mealType) {
                searchViewModel.performSearch(searchViewModel.query)
            }
        case .empty:
            contentUnavailableView(for: .noBookmarks, mealType: mealType) {
                searchViewModel.performSearch(searchViewModel.query)
            }
        case .results:
            List {
                ForEach(searchViewModel.foods, id: \.searchFoodId) { food in
                    foodRow(for: food)
                }
                pageButton(direction: .next)
                pageButton(direction: .previous)
            }
            .listStyle(.plain)
            .scrollDismissesKeyboard(.immediately)
        }
    }
    
    @ViewBuilder
    private func foodRow(for food: Food) -> some View {
        NavigationLink {
            FoodView(
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
        } label: {
            FoodDetailView(food: food, searchViewModel: searchViewModel)
        }
        .swipeActions(allowsFullSwipe: false) {
            Button(role: searchViewModel.bookmarkButtonRole(for: food)) {
                Task {
                    await searchViewModel.toggleBookmarkSearchView(for: food)
                }
                searchViewModel.uniqueId = UUID()
            } label: {
                Image(
                    systemName: searchViewModel.isBookmarkedSearchView(food)
                    ? "bookmark.slash"
                    : "bookmark"
                )
            }
            .tint(
                searchViewModel.isBookmarkedSearchView(food)
                ? .red
                : .accentColor
            )
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
    
    private var SearchViewToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Menu {
                Picker("Meal Type", selection: $mealType) {
                    ForEach(MealType.allCases, id: \.self) { meal in
                        Label(meal.rawValue, systemImage: meal.iconName)
                            .tag(meal)
                    }
                }
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: mealType.iconName)
                        .font(.system(size: 14))
                    Text(mealType.rawValue)
                }
            }
        }
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewSearchView.searchView
}
