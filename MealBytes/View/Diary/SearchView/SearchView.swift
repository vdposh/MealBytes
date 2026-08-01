//
//  SearchView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var mealType: MealType
    @State private var editModeState: EditMode = .inactive
    
    @ObservedObject var searchViewModel: SearchViewModel
    
    init(
        searchViewModel: SearchViewModel,
        mealType: MealType
    ) {
        self.searchViewModel = searchViewModel
        self._mealType = State(initialValue: mealType)
    }
    
    var body: some View {
        searchViewContentBody
            .overlay(searchableModifier)
            .searchable(
                text: $searchViewModel.query,
                placement: .navigationBarDrawer(displayMode: .always)
            )
            .navigationTitle(mealType.rawValue)
            .toolbarTitleDisplayMode(.large)
            .toolbar {
                searchViewToolbar
            }
            .toolbarVisibility(
                searchViewModel.isEditModeActive ? .hidden : .visible,
                for: .tabBar
            )
            .background {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            }
            .environment(\.editMode, $editModeState)
            .navigationBarBackButtonHidden(searchViewModel.isEditModeActive)
            .onChange(of: mealType) {
                searchViewModel.loadingBookmarks()
                
                Task {
                    await searchViewModel
                        .loadBookmarksSearchView(for: mealType)
                }
            }
            .onChange(of: searchViewModel.selectedItems) {
                withAnimation {
                    searchViewModel.uniqueId = UUID()
                }
            }
            .task {
                await searchViewModel.loadBookmarksSearchView(for: mealType)
            }
    }
    
    // MARK: - Content Body
    @ViewBuilder
    private var searchViewContentBody: some View {
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
                                .moveDisabled(!searchViewModel.isEditModeActive)
                        }
                        .onMove { indices, newOffset in
                            searchViewModel.favoriteFoods
                                .move(fromOffsets: indices, toOffset: newOffset)
                            
                            Task {
                                await searchViewModel.saveBookmarkOrder()
                            }
                        }
                    } header: {
                        Text("Bookmarks")
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
            .animation(nil, value: searchViewModel.foods)
            .animation(nil, value: searchViewModel.editingState)
            .scrollDismissesKeyboard(.immediately)
            .disabled(searchViewModel.showRemoveDialog)
        }
    }
    
    // MARK: - Food Row
    @ViewBuilder
    private func foodRow(for food: Food) -> some View {
        if searchViewModel.isEditModeActive {
            FoodDetailView(food: food)
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
                FoodDetailView(food: food)
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
    
    // MARK: - Searchable Modifier
    @ViewBuilder
    private var searchableModifier: some View {
        if searchViewModel.isEditModeActive {
            EmptyView()
                .searchable(text: $searchViewModel.query)
                .disabled(searchViewModel.isEditModeActive)
        }
    }
    
    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var searchViewToolbar: some ToolbarContent {
        switch searchViewModel.editingState {
        case .active:
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .cancel) {
                    withAnimation {
                        searchViewModel.editingState = .inactive
                    }
                    
                    searchViewModel.selectedItems.removeAll()
                    editModeState = .inactive
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                if searchViewModel.selectedItems.count
                    < searchViewModel.favoriteFoods.count {
                    Button("Select all") {
                        withAnimation {
                            searchViewModel.selectedItems = Set(
                                searchViewModel.favoriteFoods.map { $0.searchFoodId }
                            )
                        }
                    }
                    .fontWeight(.medium)
                } else {
                    Button("Cancel select") {
                        withAnimation {
                            searchViewModel.selectedItems.removeAll()
                        }
                    }
                    .fontWeight(.medium)
                }
            }
            
            ToolbarItem(placement: .status) {
                Text(searchViewModel.selectionStatusText)
                    .frame(width: 220)
                    .transaction { $0.animation = nil }
            }
            .sharedBackgroundVisibility(.hidden)
            
            ToolbarSpacer(.flexible, placement: .bottomBar)
            
            ToolbarItem(placement: .bottomBar) {
                Button(role: .destructive) {
                    searchViewModel.showRemoveDialog = true
                } label: {
                    Image(systemName: "bookmark.slash")
                }
                .transaction { $0.animation = nil }
                .disabled(
                    !searchViewModel.isEditModeActive
                    || searchViewModel.selectedItems.isEmpty
                )
                .confirmationDialog(
                    searchViewModel.removeDialogMessage,
                    isPresented: $searchViewModel.showRemoveDialog,
                    titleVisibility: .visible
                ) {
                    Button(
                        searchViewModel.removeDialogTitle,
                        role: .destructive
                    ) {
                        let idRemove = searchViewModel.selectedItems
                        searchViewModel.favoriteFoods.removeAll {
                            idRemove.contains($0.searchFoodId)
                        }
                        
                        withAnimation {
                            searchViewModel.editingState = .inactive
                        }
                        
                        searchViewModel.selectedItems.removeAll()
                        editModeState = .inactive
                        
                        Task {
                            await searchViewModel
                                .removeBookmarks(for: idRemove)
                        }
                    }
                }
            }
            
        case .inactive:
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Picker("Meal type", selection: $mealType) {
                        ForEach(MealType.allCases, id: \.self) { meal in
                            Text(meal.rawValue)
                                .tag(meal)
                        }
                    }
                    
                    if searchViewModel.canEditMealType {
                        Button {
                            searchViewModel.editingState = .active
                            
                            withAnimation {
                                editModeState = .active
                            }
                        } label: {
                            Label("Edit", systemImage: "pencil")
                            Text("Reorder and clean up")
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis")
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
