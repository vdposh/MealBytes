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
    @State private var selectedItems = Set<Food.ID>()
    @State private var editingState: EditingState = .inactive
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
        NavigationStack {
            searchViewContentBody
                .overlay(searchableModifier)
                .navigationBarTitle(mealType.rawValue)
                .navigationSubtitle(searchViewModel.bookmarkSubtitle)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    searchViewToolbar
                }
                .navigationBarBackButtonHidden(isEditing)
                .onChange(of: mealType) {
                    if searchViewModel.mealSwitch(to: mealType) {
                        Task {
                            await searchViewModel
                                .loadBookmarksSearchView(for: mealType)
                        }
                    }
                }
                .onChange(of: isEditing) {
                    if isEditing {
                        searchViewModel.resetQuery()
                    }
                }
                .task {
                    await searchViewModel
                        .loadBookmarksSearchView(for: mealType)
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
            
            List(selection: isEditing ? $selectedItems : .constant([])) {
                if searchViewModel.contentState == .results {
                    ForEach(
                        searchViewModel.foods,
                        id: \.searchFoodId
                    ) { food in
                        foodRow(for: food)
                            .moveDisabled(!isEditing)
                    }
                    .onMove { indices, newOffset in
                        searchViewModel.foods.move(
                            fromOffsets: indices,
                            toOffset: newOffset
                        )
                    }
                    pageButton(direction: .next)
                    pageButton(direction: .previous)
                }
            }
            .listStyle(.plain)
            .scrollDismissesKeyboard(.immediately)
        }
    }
    
    private var searchableModifier: some View {
        return EmptyView()
            .searchable(
                text: $searchViewModel.query,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search for food"
            )
            .disabled(isEditing)
    }
    
    @ViewBuilder
    private func foodRow(for food: Food) -> some View {
        if isEditing {
            FoodDetailView(
                food: food,
                isEditing: isEditing,
                searchViewModel: searchViewModel
            )
        } else {
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
                FoodDetailView(
                    food: food,
                    isEditing: isEditing,
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
                    Image(
                        systemName: searchViewModel
                            .isBookmarkedSearchView(food)
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
    
    @ToolbarContentBuilder
    private var searchViewToolbar: some ToolbarContent {
        switch editingState {
        case .active:
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    searchViewModel.removalBookmarks.formUnion(selectedItems)
                    withAnimation {
                        searchViewModel.foods.removeAll { food in
                            selectedItems.contains(food.searchFoodId)
                        }
                    }
                    selectedItems.removeAll()
                } label: {
                    Image(systemName: "bookmark.slash")
                }
                .disabled(selectedItems.isEmpty)
                .tint(.customRed)
            }
            
            ToolbarSpacer(.fixed, placement: .topBarTrailing)
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    editingState = .inactive
                    withAnimation {
                        editMode?.wrappedValue = .inactive
                    }
                    searchViewModel.removalBookmarks.removeAll()
                    searchViewModel.foods = searchViewModel.favoriteFoods
                } label: {
                    Image(systemName: "xmark")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editingState = .inactive
                    withAnimation {
                        editMode?.wrappedValue = .inactive
                    }
                    searchViewModel.favoriteFoods.removeAll { food in
                        searchViewModel.removalBookmarks
                            .contains(food.searchFoodId)
                    }
                    searchViewModel.bookmarkedFoods
                        .subtract(searchViewModel.removalBookmarks)
                    searchViewModel.removalBookmarks.removeAll()
                    
                    Task {
                        await searchViewModel.saveBookmarkOrder()
                    }
                } label: {
                    Image(systemName: "checkmark")
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
                    
                    Section("Settings") {
                        Button {
                            editingState = .active
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
    
    private var isEditing: Bool {
        editingState == .active
    }
    
    enum EditingState {
        case inactive
        case active
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewSearchView.searchView
}
