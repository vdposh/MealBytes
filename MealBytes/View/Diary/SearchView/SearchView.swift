//
//  SearchView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var mealType: MealType
    @Environment(\.editMode) private var editMode
    
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
            .navigationTitle(mealType.rawValue)
            .navigationSubtitle(searchViewModel.subtitleText)
            .toolbarTitleDisplayMode(.large)
            .toolbar {
                searchViewToolbar
            }
            .toolbarVisibility(
                searchViewModel.isEditModeActive ? .hidden : .visible,
                for: .tabBar
            )
            .navigationBarBackButtonHidden(searchViewModel.isEditModeActive)
            .onChange(of: mealType) {
                searchViewModel.isLoadingBookmarks = true
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
    }
    
    @ViewBuilder
    private var searchViewContentBody: some View {
        ZStack {
            if searchViewModel.contentState == .loading {
                LoadingView()
            } else if case .error(let error) = searchViewModel.contentState {
                contentUnavailableView(for: error, mealType: mealType) {
                    searchViewModel.performSearch(searchViewModel.query)
                }
            } else if searchViewModel.contentState == .empty {
                contentUnavailableView(for: .noBookmarks, mealType: mealType) {
                    searchViewModel.performSearch(searchViewModel.query)
                }
            }
            
            List(
                selection: searchViewModel.isEditModeActive
                ? $searchViewModel.selectedItems
                : .constant([])
            ) {
                if searchViewModel.contentState == .results {
                    ForEach(
                        searchViewModel.foods,
                        id: \.searchFoodId
                    ) { food in
                        foodRow(for: food)
                            .moveDisabled(!searchViewModel.isEditModeActive)
                    }
                    .onMove { indices, newOffset in
                        searchViewModel.foods.move(
                            fromOffsets: indices,
                            toOffset: newOffset
                        )
                        Task {
                            await searchViewModel.saveBookmarkOrder()
                        }
                    }
                    
                    pageButton(direction: .next)
                    pageButton(direction: .previous)
                }
            }
            .transaction { $0.animation = nil }
            .listStyle(.plain)
            .scrollDismissesKeyboard(.immediately)
            .disabled(searchViewModel.showRemoveDialog)
        }
    }
    
    @ViewBuilder
    private func foodRow(for food: Food) -> some View {
        if searchViewModel.isEditModeActive {
            FoodDetailView(
                food: food,
                isEditing: searchViewModel.isEditModeActive,
                searchViewModel: searchViewModel
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
                    isEditing: searchViewModel.isEditModeActive,
                    searchViewModel: searchViewModel
                )
            }
            .swipeActions(allowsFullSwipe: false) {
                Button(role: searchViewModel.bookmarkButtonRole(for: food)) {
                    Task {
                        await searchViewModel
                            .toggleBookmarkSearchView(for: food)
                    }
                    searchViewModel.uniqueId = UUID()
                } label: {
                    Label(
                        searchViewModel.isBookmarkedSearchView(food)
                        ? "Remove bookmark"
                        : "Add to favorites",
                        systemImage: searchViewModel
                            .isBookmarkedSearchView(food)
                        ? "bookmark.slash"
                        : "bookmark"
                    )
                }
                .tint(
                    searchViewModel.isBookmarkedSearchView(food)
                    ? .red
                    : .accent
                )
            }
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
    
    private var searchableModifier: some View {
        return EmptyView()
            .searchable(
                text: $searchViewModel.query,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search"
            )
            .disabled(searchViewModel.isEditModeActive)
    }
    
    @ToolbarContentBuilder
    private var searchViewToolbar: some ToolbarContent {
        switch searchViewModel.editingState {
        case .active:
            ToolbarItem(placement: .topBarTrailing) {
                Button(role: .cancel) {
                    withAnimation {
                        searchViewModel.selectedItems.removeAll()
                    }
                    withTransaction(
                        Transaction(animation: .bouncy)
                    ) {
                        searchViewModel.editingState = .inactive
                    }
                    editMode?.wrappedValue = .inactive
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                if searchViewModel.selectedItems.count
                    < searchViewModel.foods.count {
                    Button("Select all") {
                        withAnimation {
                            searchViewModel.selectedItems = Set(
                                searchViewModel.foods.map { $0.searchFoodId }
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
                        searchViewModel.foods.removeAll {
                            idRemove.contains($0.searchFoodId)
                        }
                        searchViewModel.selectedItems.removeAll()
                        withTransaction(
                            Transaction(animation: .bouncy)
                        ) {
                            searchViewModel.editingState = .inactive
                        }
                        editMode?.wrappedValue = .inactive
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
                    Picker("Meal Type", selection: $mealType) {
                        ForEach(MealType.allCases, id: \.self) { meal in
                            Label(meal.rawValue, systemImage: meal.iconName)
                                .tag(meal)
                        }
                    }
                    
                    if !searchViewModel.foods.isEmpty {
                        Button {
                            searchViewModel.editingState = .active
                            withAnimation {
                                editMode?.wrappedValue = .active
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
