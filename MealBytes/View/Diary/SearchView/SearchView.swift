//
//  SearchView.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI

struct SearchView: View {
    @State private var editModeState: EditMode = .inactive
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var searchViewModel: SearchViewModel
    
    init(searchViewModel: SearchViewModel) {
        self.searchViewModel = searchViewModel
    }
    
    var body: some View {
        SearchViewContent(
            editModeState: $editModeState,
            searchViewModel: searchViewModel,
            mealType: searchViewModel.selectedMealType
        )
        .searchable(text: $searchViewModel.query)
        .environment(\.editMode, $editModeState)
        .navigationTitle(searchViewModel.selectedMealType.rawValue)
        .navigationSubtitle(searchViewModel.navigationSubtitleText)
        .toolbarTitleDisplayMode(.inline)
        .toolbar {
            switch toolbarMode {
            case .editingBookmarks:
                editingBookmarksToolbar
            case .editingRecent:
                editingRecentToolbar
            case .viewing:
                viewingToolbar
            }
        }
        .safeAreaBar(edge: .top) {
            segmentPickerView
        }
        .scrollEdgeEffectStyle(.soft, for: .top)
        .scrollEdgeEffectHidden(for: .bottom)
        .onChange(of: editModeState) {
            withAnimation {
                searchViewModel.isEditingActive = editModeState.isEditing
            }
        }
    }
    
    // MARK: - Toolbar Mode
    private enum ToolbarMode {
        case editingBookmarks
        case editingRecent
        case viewing
    }
    
    private var toolbarMode: ToolbarMode {
        if searchViewModel.isEditingActive {
            return searchViewModel.selectedSegment == .bookmarks
            ? .editingBookmarks
            : .editingRecent
        }
        return .viewing
    }
    
    // MARK: - Editing Toolbars
    @ToolbarContentBuilder
    private var editingBookmarksToolbar: some ToolbarContent {
        editingConfirmButton
        editingLeadingSelectionButton
        ToolbarSpacer(.flexible, placement: .bottomBar)
        editingBookmarksBottomBar
    }
    
    @ToolbarContentBuilder
    private var editingRecentToolbar: some ToolbarContent {
        editingConfirmButton
        editingLeadingSelectionButton
        ToolbarSpacer(.flexible, placement: .bottomBar)
        editingRecentBottomBar
    }
    
    // MARK: - Viewing Toolbar
    @ToolbarContentBuilder
    private var viewingToolbar: some ToolbarContent {
        viewingSelectButton
        viewingCloseButton
        DefaultToolbarItem(kind: .search, placement: .bottomBar)
        ToolbarTitleMenu {
            mealTypePicker
        }
    }
    
    // MARK: - Editing Buttons
    @ToolbarContentBuilder
    private var editingConfirmButton: some ToolbarContent {
        ToolbarItem {
            Button(role: .confirm) {
                exitEditMode()
            }
        }
    }
    
    @ToolbarContentBuilder
    private var editingLeadingSelectionButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            selectionToggleButton
        }
    }
    
    @ViewBuilder
    private var selectionToggleButton: some View {
        let sourceIds = currentSourceIds
        
        if !sourceIds.isEmpty {
            if sourceIds.isSubset(of: searchViewModel.selectedItems) {
                Button("Deselect All") {
                    withAnimation {
                        searchViewModel.selectedItems.subtract(sourceIds)
                    }
                }
                .fontWeight(.medium)
            } else {
                Button("Select All") {
                    withAnimation {
                        searchViewModel.selectedItems.formUnion(sourceIds)
                    }
                }
                .fontWeight(.medium)
            }
        }
    }
    
    private var currentSourceIds: Set<Food.ID> {
        let sourceFoods = searchViewModel.selectedSegment == .bookmarks
        ? searchViewModel.favoriteFoods
        : searchViewModel.historyFoods
        return Set(sourceFoods.map { $0.searchFoodId })
    }
    
    // MARK: - Editing Bookmarks Bottom Bar
    @ToolbarContentBuilder
    private var editingBookmarksBottomBar: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            bookmarksMealTypeMenu
            bookmarksRemoveButton
        }
    }
    
    private var bookmarksMealTypeMenu: some View {
        Menu {
            Picker(
                "Meal Type",
                selection: Binding(
                    get: { searchViewModel.selectedMealType },
                    set: { newMealType in
                        let ids = searchViewModel.selectedItems
                        let foodsToMove = searchViewModel
                            .favoriteFoods.filter {
                                ids.contains($0.searchFoodId)
                            }
                        
                        exitEditMode()
                        
                        Task {
                            await searchViewModel
                                .transferBookmarks(
                                    for: foodsToMove,
                                    to: newMealType
                                )
                        }
                    }
                )
            ) {
                ForEach(MealType.allCases, id: \.self) { meal in
                    Text(meal.rawValue).tag(meal)
                }
            }
        } label: {
            Image(systemName: "fork.knife")
        }
        .menuOrder(.fixed)
        .transaction { $0.animation = nil }
        .disabled(searchViewModel.selectedBookmarksCount == 0)
    }
    
    private var bookmarksRemoveButton: some View {
        Button {
            searchViewModel.showRemoveBookmarksDialog = true
        } label: {
            Image(systemName: "bookmark.slash")
        }
        .transaction { $0.animation = nil }
        .disabled(searchViewModel.selectedBookmarksCount == 0)
        .confirmationDialog(
            searchViewModel.removeDialogMessage,
            isPresented: $searchViewModel.showRemoveBookmarksDialog,
            titleVisibility: .visible
        ) {
            Button(role: .destructive) {
                let ids = searchViewModel.selectedItems
                exitEditMode()
                Task {
                    await searchViewModel.removeSelectedBookmarks(ids: ids)
                }
            } label: {
                Text(searchViewModel.removeDialogTitle)
            }
        }
    }
    
    // MARK: - Editing Recent Bottom Bar
    @ToolbarContentBuilder
    private var editingRecentBottomBar: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            recentAddBookmarksButton
            recentDeleteButton
        }
    }
    
    private var recentAddBookmarksButton: some View {
        Button {
            let ids = searchViewModel.selectedItems
            let foodsToAdd = searchViewModel.historyFoods.filter {
                ids.contains($0.searchFoodId)
            }
            
            exitEditMode()
            
            Task {
                for food in foodsToAdd {
                    await searchViewModel
                        .toggleBookmarkSearchView(for: food)
                }
            }
        } label: {
            Image(systemName: "bookmark")
        }
        .transaction { $0.animation = nil }
        .disabled(searchViewModel.selectedHistoryCount == 0)
    }
    
    private var recentDeleteButton: some View {
        Button(role: .destructive) {
            searchViewModel.showRemoveHistoryDialog = true
        }
        .transaction { $0.animation = nil }
        .disabled(searchViewModel.selectedHistoryCount == 0)
        .confirmationDialog(
            searchViewModel.deleteHistoryDialogMessage,
            isPresented: $searchViewModel.showRemoveHistoryDialog,
            titleVisibility: .visible
        ) {
            Button(role: .destructive) {
                let ids = searchViewModel.selectedItems
                exitEditMode()
                Task {
                    await searchViewModel.deleteHistoryItem(for: ids)
                }
            } label: {
                Text(searchViewModel.deleteHistoryDialogTitle)
            }
        }
    }
    
    // MARK: - Viewing Buttons
    @ToolbarContentBuilder
    private var viewingSelectButton: some ToolbarContent {
        if canEnterEditMode {
            ToolbarItem {
                Button("Select") {
                    enterEditMode()
                }
                .fontWeight(.medium)
            }
        }
    }
    
    private var canEnterEditMode: Bool {
        switch searchViewModel.selectedSegment {
        case .bookmarks:
            return !searchViewModel.favoriteFoods.isEmpty
        case .recent:
            return !searchViewModel.historyFoods.isEmpty
        }
    }
    
    @ToolbarContentBuilder
    private var viewingCloseButton: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button(role: .close) {
                dismiss()
            } label: {
                Text("Close")
                    .fontWeight(.medium)
            }
        }
    }
    
    private var mealTypePicker: some View {
        Picker(
            "Meal Type",
            selection: Binding(
                get: { searchViewModel.selectedMealType },
                set: { searchViewModel.displaySearchViewData(for: $0) }
            )
        ) {
            ForEach(MealType.allCases, id: \.self) { meal in
                Text(meal.rawValue).tag(meal)
            }
        }
    }
    
    // MARK: - Segment Picker
    @ViewBuilder
    private var segmentPickerView: some View {
        if searchViewModel.query.isEmpty &&
            searchViewModel.debouncedQuery.isEmpty &&
            (!searchViewModel.favoriteFoods.isEmpty ||
             !searchViewModel.historyFoods.isEmpty) {
            Picker(
                "Section",
                selection: Binding(
                    get: { searchViewModel.selectedSegment },
                    set: { searchViewModel.selectSegment($0) }
                )
            ) {
                ForEach(ListSegment.allCases, id: \.self) { segment in
                    Text(segment.rawValue).tag(segment)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .padding(.top, 6)
            .padding(.bottom, 2)
        }
    }
    
    // MARK: - UI Helper
    private func enterEditMode() {
        withAnimation {
            editModeState = .active
        }
    }
    
    private func exitEditMode() {
        guard !searchViewModel.isMoving else { return }
        
        withAnimation {
            editModeState = .inactive
        }
        
        searchViewModel.selectedItems.removeAll()
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewSearchView.searchView
}
