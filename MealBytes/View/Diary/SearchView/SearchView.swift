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
        .navigationTitle(searchViewModel.selectedMealType.rawValue)
        .toolbarTitleDisplayMode(.inline)
        .toolbarTitleMenu {
            mealTypePicker
        }
        .toolbar {
            searchViewToolbar
        }
        .environment(\.editMode, $editModeState)
        .onDisappear {
            resetEditingState()
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
                    resetEditingState()
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
                        Text("Select all")
                            .fontWeight(.medium)
                    }
                } else {
                    Button {
                        withAnimation {
                            searchViewModel.selectedItems.removeAll()
                        }
                    } label: {
                        Text("Cancel select")
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
                        
                        resetEditingState()
                        
                        Task {
                            await searchViewModel
                                .removeBookmarks(for: idRemove)
                        }
                    }
                }
            }
            
            ToolbarSpacer(.flexible, placement: .bottomBar)
            
        case .inactive:
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
    
    private func resetEditingState() {
        withAnimation {
            searchViewModel.editingState = .inactive
        }
        
        searchViewModel.selectedItems.removeAll()
        editModeState = .inactive
    }
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewSearchView.searchView
}
