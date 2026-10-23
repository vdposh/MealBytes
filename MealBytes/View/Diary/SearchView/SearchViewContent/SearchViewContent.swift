//
//  SearchViewContent.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 20.08.2026.
//

import SwiftUI

struct SearchViewContent: View {
    @Binding var editModeState: EditMode
    @ObservedObject var searchViewModel: SearchViewModel
    
    let mealType: MealType
    
    var body: some View {
        switch searchViewModel.contentState {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        case .error(let error):
            contentUnavailableView(for: error, mealType: mealType) {
                searchViewModel.performSearch(searchViewModel.query)
            }
            
        case .emptyEntries:
            contentUnavailableView(for: .noEntries, mealType: mealType) {}
            
        case .emptyBookmarks:
            contentUnavailableView(for: .noBookmarks, mealType: mealType) {
                searchViewModel.performSearch(searchViewModel.query)
            }
            
        case .emptyRecent:
            contentUnavailableView(for: .noRecent, mealType: mealType) {}
            
        case .results:
            List(
                selection: editModeState.isEditing
                ? $searchViewModel.selectedItems
                : .constant([])
            ) {
                // MARK: - Bookmarks Section
                if searchViewModel.selectedSegment == .bookmarks ||
                    !searchViewModel.debouncedQuery.isEmpty {
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
                                    .moveDisabled(!editModeState.isEditing)
                            }
                            .onMove { indices, newOffset in
                                searchViewModel.moveBookmarks(
                                    from: indices,
                                    to: newOffset,
                                    in: filteredBookmarks
                                )
                            }
                        } header: {
                            Text("Bookmarks")
                        }
                    }
                }
                
                // MARK: - History Section
                if searchViewModel.selectedSegment == .recent,
                   !searchViewModel.historyFoods.isEmpty,
                   searchViewModel.debouncedQuery.isEmpty {
                    Section {
                        ForEach(
                            searchViewModel.historyFoods,
                            id: \.searchFoodId
                        ) { food in
                            foodRow(for: food)
                        }
                    } header: {
                        Text("Recent")
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
            .navigationDestination(
                item: $searchViewModel.selectedFood
            ) { food in
                FoodView(
                    mealType: mealType,
                    food: food,
                    searchViewModel: searchViewModel,
                    mainViewModel: searchViewModel.mainViewModel,
                    amount: "",
                    measurementDescription: "",
                    isEditingMealItem: false
                )
            }
            .onChange(of: searchViewModel.selectedItems) {
                withAnimation {
                    searchViewModel
                        .selectedItems = searchViewModel.selectedItems
                }
            }
            .onChange(of: editModeState) {
                withAnimation {
                    searchViewModel.isEditingActive = editModeState.isEditing
                }
            }
        }
    }
    
    // MARK: - Food Row
    private func foodRow(for food: Food) -> some View {
        Button {
            searchViewModel.selectedFood = food
        } label: {
            FoodDetailView(
                food: food,
                foodMetadata: searchViewModel
                    .foodMetadataDict[food.searchFoodId],
                energyUnit: searchViewModel.energyUnit,
                showChevron: !editModeState.isEditing
            )
        }
        .swipeActions {
            Button(role: .destructive) {
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
                            .font(.footnote)
                        
                        Text("Next Page")
                    }
                    
                case .previous:
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.footnote)
                        
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
