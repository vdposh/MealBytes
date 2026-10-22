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
        .toolbarTitleDisplayMode(.inline)
        .toolbarTitleMenu {
            mealTypePicker
        }
        .toolbar {
            searchViewToolbar
        }
        .safeAreaBar(edge: .top) {
            segmentPickerView
        }
        .scrollEdgeEffectStyle(.soft, for: .top)
        .scrollEdgeEffectHidden(for: .bottom)
        .onDisappear {
            exitEditMode()
        }
    }
    
    // MARK: - Toolbar
    private var mealTypePicker: some View {
        Picker(
            "Meal type",
            selection: Binding(
                get: { searchViewModel.selectedMealType },
                set: { searchViewModel.displaySearchViewData(for: $0) }
            )
        ) {
            ForEach(MealType.allCases, id: \.self) { meal in
                Text(meal.rawValue).tag(meal)
            }
        }
        .disabled(searchViewModel.isEditModeActive)
    }
    
    @ToolbarContentBuilder
    private var searchViewToolbar: some ToolbarContent {
        switch searchViewModel.editingState {
        case .active:
            ToolbarItem {
                Button(role: .confirm) {
                    exitEditMode()
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                if searchViewModel.selectedItems.count
                    < searchViewModel.favoriteFoods.count {
                    Button {
                        withAnimation {
                            searchViewModel.selectedItems = Set(
                                searchViewModel.favoriteFoods
                                    .map { $0.searchFoodId }
                            )
                        }
                    } label: {
                        Text("Select All")
                            .fontWeight(.medium)
                    }
                } else {
                    Button {
                        withAnimation {
                            searchViewModel.selectedItems.removeAll()
                        }
                    } label: {
                        Text("Deselect All")
                            .fontWeight(.medium)
                    }
                }
            }
            
            ToolbarItem(placement: .status) {
                Text(searchViewModel.selectionStatusText)
                    .fixedSize()
                    .transaction { $0.animation = nil }
            }
            .sharedBackgroundVisibility(.hidden)
            
            ToolbarItem(placement: .bottomBar) {
                Button(role: .destructive) {
                    searchViewModel.showRemoveDialog = true
                } label: {
                    Image(systemName: "bookmark.slash")
                }
                .transaction { $0.animation = nil }
                .disabled(
                    !searchViewModel.isEditModeActive ||
                    searchViewModel.selectedItems.isEmpty
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
                        
                        exitEditMode()
                        
                        Task {
                            await searchViewModel
                                .removeBookmarks(for: idRemove)
                        }
                    }
                }
            }
            
            ToolbarSpacer(.flexible, placement: .bottomBar)
            
        case .inactive:
            if searchViewModel.selectedSegment == .bookmarks &&
                !searchViewModel.favoriteFoods.isEmpty {
                ToolbarItem {
                    Button {
                        enterEditMode()
                    } label: {
                        Text("Select")
                            .fontWeight(.medium)
                    }
                }
            }
            
            ToolbarItem(placement: .cancellationAction) {
                Button(role: .close) {
                    dismiss()
                } label: {
                    Text("Close")
                        .fontWeight(.medium)
                }
            }
            
            DefaultToolbarItem(kind: .search, placement: .bottomBar)
        }
    }
    
    // MARK: - Segment Picker
    @ViewBuilder
    private var segmentPickerView: some View {
        if searchViewModel.query.isEmpty &&
            searchViewModel.debouncedQuery.isEmpty &&
            (
                !searchViewModel.favoriteFoods.isEmpty ||
                !searchViewModel.historyFoods.isEmpty
            ) {
            Picker(
                "Section",
                selection: $searchViewModel.selectedSegment
            ) {
                ForEach(
                    SearchViewListSegment.allCases,
                    id: \.self
                ) { segment in
                    Text(segment.rawValue).tag(segment)
                }
            }
            .pickerStyle(.segmented)
            .disabled(searchViewModel.isEditModeActive)
            .padding(.horizontal)
            .padding(.top, 6)
            .padding(.bottom, 4)
        }
    }
    
    // MARK: - UI Helper
    private func exitEditMode() {
        withAnimation {
            searchViewModel.editingState = .inactive
        }
        
        searchViewModel.selectedItems.removeAll()
        editModeState = .inactive
    }
    
    private func enterEditMode() {
        withAnimation {
            searchViewModel.editingState = .active
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation {
                editModeState = .active
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
