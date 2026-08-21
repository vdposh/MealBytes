//
//  SearchViewContent.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 20.08.2026.
//

import SwiftUI

struct SearchViewContent: View {
    @Binding var editModeState: EditMode
    @Environment(\.isSearching) private var isSearching
    
    @ObservedObject var searchViewModel: SearchViewModel
    
    let mealType: MealType
    
    var body: some View {
        switch searchViewModel.contentState {
        case .loading:
            LoadingView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .error(let error):
            contentUnavailableView(for: error, mealType: mealType) {
                searchViewModel.performSearch(searchViewModel.query)
            }
            
        case .empty:
            contentUnavailableView(for: .noBookmarks, mealType: mealType) {
                searchViewModel.performSearch(searchViewModel.query)
            }
            
        case .results:
            List(
                selection: searchViewModel.isEditModeActive
                ? $searchViewModel.selectedItems
                : .constant([])
            ) {
                // MARK: - Bookmarks Section
                let filteredBookmarks = searchViewModel
                    .favoriteFoods.filter { food in
                        let query = searchViewModel.debouncedQuery
                        if query.isEmpty {
                            return true
                        } else {
                            return food.searchFoodName
                                .lowercased()
                                .contains(query.lowercased())
                        }
                    }
                
                if !filteredBookmarks.isEmpty {
                    Section {
                        ForEach(
                            filteredBookmarks,
                            id: \.searchFoodId
                        ) { food in
                            foodRow(for: food)
                                .moveDisabled(
                                    !searchViewModel.isEditModeActive
                                )
                        }
                        .onMove { indices, newOffset in
                            searchViewModel.moveBookmarks(
                                from: indices,
                                to: newOffset,
                                in: filteredBookmarks
                            )
                        }
                    } header: {
                        HeaderButtonView(
                            mealType: mealType,
                            title: "Bookmarks",
                            isEdit: !searchViewModel.isEditModeActive &&
                            !isSearching
                        ) {
                            withAnimation {
                                searchViewModel.editingState = .active
                            }
                            
                            DispatchQueue.main
                                .asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation {
                                        editModeState = .active
                                    }
                                }
                        }
                    }
                }
                
                // MARK: - Results Section
                if !searchViewModel.debouncedQuery.isEmpty {
                    let filteredResults = searchViewModel
                        .foods.filter { food in
                            !searchViewModel.isBookmarkedSearchView(food)
                        }
                    
                    if !filteredResults.isEmpty {
                        Section {
                            ForEach(
                                filteredResults,
                                id: \.searchFoodId
                            ) { food in
                                foodRow(for: food)
                            }
                            
                            if searchViewModel.showPagination {
                                pageButton(direction: .next)
                                pageButton(direction: .previous)
                            }
                        } header: {
                            Text("Results")
                        }
                    }
                }
            }
            .animation(nil, value: searchViewModel.editingState)
            .animation(nil, value: searchViewModel.foods)
            .scrollDismissesKeyboard(.immediately)
            .overlay {
                FoodAddedAlertView(
                    isVisible: $searchViewModel.isFoodAddedAlertVisible
                )
                .animation(
                    .bouncy(duration: 0.3),
                    value: searchViewModel.isFoodAddedAlertVisible
                )
            }
            .disabled(searchViewModel.showRemoveDialog)
        }
    }
    
    // MARK: - Food Row
    @ViewBuilder
    private func foodRow(for food: Food) -> some View {
        if searchViewModel.isEditModeActive {
            FoodDetailView(
                food: food,
                bookmarkMetadata: searchViewModel
                    .bookmarkMetadataDict[food.searchFoodId]
            )
        } else {
            NavigationLink {
                FoodView(
                    mealType: mealType,
                    food: food,
                    searchViewModel: searchViewModel,
                    mainViewModel: searchViewModel.mainViewModel,
                    amount: "",
                    measurementDescription: "",
                    isEditingMealItem: false
                )
            } label: {
                FoodDetailView(
                    food: food,
                    bookmarkMetadata: searchViewModel
                        .bookmarkMetadataDict[food.searchFoodId]
                )
            }
            .swipeActions {
                Button(
                    role: searchViewModel.isBookmarkedSearchView(food)
                    ? .destructive
                    : nil
                ) {
                    Task {
                        await searchViewModel
                            .toggleBookmarkSearchView(for: food)
                    }
                } label: {
                    Label {
                        Text(
                            searchViewModel
                                .isBookmarkedSearchView(food)
                            ? "Remove bookmark"
                            : "Add bookmark"
                        )
                    } icon: {
                        Image(
                            systemName: searchViewModel
                                .isBookmarkedSearchView(food)
                            ? "bookmark.slash"
                            : "bookmark"
                        )
                    }
                }
                .tint(
                    searchViewModel.isBookmarkedSearchView(food)
                    ? .red
                    : .accent
                )
            }
        }
    }
    
    // MARK: - Page Buttons
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
