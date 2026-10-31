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
        searchViewCore
            .environment(\.editMode, $editModeState)
            .navigationTitle(searchViewModel.selectedMealType.rawValue)
            .navigationSubtitle(searchViewModel.navigationSubtitleText)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                searchViewToolbar
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
    
    @ViewBuilder
    private var searchViewCore: some View {
        let content = SearchViewContent(
            editModeState: $editModeState,
            searchViewModel: searchViewModel,
            mealType: searchViewModel.selectedMealType
        )
        
        if searchViewModel.isAddingLoading {
            content
        } else {
            content.searchable(text: $searchViewModel.query)
        }
    }
    
    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var searchViewToolbar: some ToolbarContent {
        if searchViewModel.isEditingActive {
            selectAllButton
            addButton
            cancelEditButton
            bookmarksBottomBar
            recentBottomBar
        } else {
            selectButton
            closeButton
            
            DefaultToolbarItem(kind: .search, placement: .bottomBar)
            
            ToolbarTitleMenu {
                mealTypePicker
            }
        }
    }
    
    // MARK: - Editing Buttons
    @ToolbarContentBuilder
    private var cancelEditButton: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button {
                exitEditMode()
            } label: {
                Text("Cancel")
            }
        }
    }
    
    @ToolbarContentBuilder
    private var selectAllButton: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            let sourceIds = searchViewModel.currentSegmentFoodIds
            
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
    }
    
    // MARK: - Bookmarks Bottom Bar
    @ToolbarContentBuilder
    private var bookmarksBottomBar: some ToolbarContent {
        if searchViewModel.selectedSegment == .bookmarks {
            ToolbarSpacer(.flexible, placement: .bottomBar)
            bookmarksMealTypeMenu
            bookmarksRemoveButton
        }
    }
    
    @ToolbarContentBuilder
    private var addButton: some ToolbarContent {
        ToolbarItem {
            Button(role: .confirm) {
                let foodsToAdd = searchViewModel.selectedFoodsToAdd
                let allHaveMetadata = foodsToAdd.allSatisfy {
                    searchViewModel.foodMetadataDict[$0.searchFoodId] != nil
                }
                
                if allHaveMetadata {
                    dismiss()
                    
                    Task {
                        await searchViewModel.addMealItemsBatch(
                            for: foodsToAdd,
                            to: searchViewModel.selectedMealType,
                            on: searchViewModel.mainViewModel.date,
                            showFeedback: false
                        )
                    }
                } else {
                    exitEditMode()
                    
                    Task {
                        await searchViewModel.addMealItemsBatch(
                            for: foodsToAdd,
                            to: searchViewModel.selectedMealType,
                            on: searchViewModel.mainViewModel.date
                        )
                        
                        dismiss()
                    }
                }
            } label: {
                Text("Add")
                    .fontWeight(.medium)
            }
            .transaction { $0.animation = nil }
            .badge(searchViewModel.selectedItems.count)
            .disabled(searchViewModel.selectedItems.isEmpty)
        }
    }
    
    @ToolbarContentBuilder
    private var bookmarksMealTypeMenu: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Menu {
                Picker(
                    searchViewModel.moveToMenuTitle,
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
                .labelsVisibility(.visible)
            } label: {
                Image(systemName: "fork.knife")
            }
            .menuOrder(.fixed)
            .transaction { $0.animation = nil }
            .disabled(searchViewModel.selectedBookmarksCount == 0)
        }
    }
    
    @ToolbarContentBuilder
    private var bookmarksRemoveButton: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
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
    }
    
    // MARK: - Editing Recent Bottom Bar
    @ToolbarContentBuilder
    private var recentBottomBar: some ToolbarContent {
        if searchViewModel.selectedSegment == .recent {
            ToolbarSpacer(.flexible, placement: .bottomBar)
            recentAddBookmarksButton
            recentDeleteButton
        }
    }
    
    @ToolbarContentBuilder
    private var recentAddBookmarksButton: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            Button {
                let ids = searchViewModel.selectedItems
                let foodsToAdd = searchViewModel.historyFoods.filter {
                    ids.contains($0.searchFoodId)
                }
                
                exitEditMode()
                
                Task {
                    await searchViewModel.addBookmarks(for: foodsToAdd)
                }
            } label: {
                Image(systemName: "bookmark")
            }
            .transaction { $0.animation = nil }
            .disabled(searchViewModel.selectedHistoryCount == 0)
        }
    }
    
    @ToolbarContentBuilder
    private var recentDeleteButton: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
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
    }
    
    // MARK: - Viewing Buttons
    @ToolbarContentBuilder
    private var selectButton: some ToolbarContent {
        if canEnterEditMode && !searchViewModel.isAddingLoading {
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
    private var closeButton: some ToolbarContent {
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
            !searchViewModel.isAddingLoading &&
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
            .padding(.top, 4)
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
