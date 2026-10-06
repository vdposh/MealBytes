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
            ProgressView()
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
                    .animation(nil, value: searchViewModel.foods)
                }
                
                // MARK: - History Section
                if !searchViewModel.historyFoods.isEmpty &&
                    searchViewModel.debouncedQuery.isEmpty &&
                    !searchViewModel.isEditModeActive {
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
                    .selectionDisabled(
                        !searchViewModel.isEditModeActive ||
                        searchViewModel.isEditModeActive
                    )
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
                        .animation(nil, value: searchViewModel.foods)
                    }
                }
            }
            .animation(nil, value: searchViewModel.editingState)
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
            .onChange(of: searchViewModel.selectedItems) {
                withAnimation {
                    searchViewModel.selectedItems = searchViewModel
                        .selectedItems
                }
            }
        }
    }
    
    // MARK: - Food Row
    @ViewBuilder
    private func foodRow(for food: Food) -> some View {
        if searchViewModel.isEditModeActive {
            FoodDetailView(
                food: food,
                foodMetadata: searchViewModel
                    .foodMetadataDict[food.searchFoodId],
                energyUnit: searchViewModel.energyUnit
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
                    foodMetadata: searchViewModel
                        .foodMetadataDict[food.searchFoodId],
                    energyUnit: searchViewModel.energyUnit
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
