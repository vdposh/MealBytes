//
//  SearchView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var mealType: MealType
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
        searchViewContentBody
            .overlay(searchableModifier)
            .navigationTitle(mealType.rawValue)
            .toolbarTitleDisplayMode(.large)
            .toolbar {
                searchViewToolbar
            }
            .toolbarVisibility(isEditing ? .hidden : .visible, for: .tabBar)
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
                        Task {
                            await searchViewModel.saveBookmarkOrder()
                        }
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
                    showSaveRemoveButton: false
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
            ToolbarItem(placement: .bottomBar) {
                Text(selectionStatusText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .sharedBackgroundVisibility(.hidden)
            
            ToolbarItem(placement: .bottomBar) {
                Menu {
                    Section("Remove bookmarks from the favorites") {
                        Button(role: .destructive) {
                            Task {
                                await searchViewModel
                                    .removeBookmarks(for: selectedItems)
                                selectedItems.removeAll()
                            }
                        } label: {
                            Label(
                                removeDialogTitle,
                                systemImage: "bookmark.slash"
                            )
                        }
                    }
                } label: {
                    Image(systemName: "bookmark.slash")
                }
                .disabled(selectedItems.isEmpty)
            }
            
            ToolbarItemGroup(placement: .topBarLeading) {
                if selectedItems.count < searchViewModel.foods.count {
                    Button {
                        selectedItems = Set(
                            searchViewModel.foods.map { $0.searchFoodId }
                        )
                    } label: {
                        Text("Select all")
                            .fontWeight(.medium)
                    }
                } else {
                    Button {
                        selectedItems.removeAll()
                    } label: {
                        Text("Cancel select")
                            .fontWeight(.medium)
                    }
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    editingState = .inactive
                    withAnimation {
                        editMode?.wrappedValue = .inactive
                    }
                    selectedItems.removeAll()
                } label: {
                    Image(systemName: "xmark")
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
                    
                    Button {
                        editingState = .active
                        withAnimation {
                            editMode?.wrappedValue = .active
                        }
                    } label: {
                        Label("Edit", systemImage: "pencil")
                        Text("Reorder and clean up")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
    
    private var removeDialogTitle: String {
        let count = selectedItems.count
        return count == 1
        ? "Remove bookmark"
        : "Remove \(count) bookmarks"
    }
    
    private var selectionStatusText: String {
        selectedItems.isEmpty
        ? "Select bookmarks"
        : selectedItems.count == 1
        ? "1 Bookmark Selected"
        : "\(selectedItems.count) Bookmarks Selected"
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
