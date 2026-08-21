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
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var searchViewModel: SearchViewModel
    
    init(
        searchViewModel: SearchViewModel,
        mealType: MealType
    ) {
        self.searchViewModel = searchViewModel
        self._mealType = State(initialValue: mealType)
    }
    
    var body: some View {
        SearchViewContent(
            editModeState: $editModeState,
            searchViewModel: searchViewModel,
            mealType: mealType
        )
        .searchable(text: $searchViewModel.query)
        .navigationTitle(mealType.rawValue)
        .toolbarTitleDisplayMode(.inline)
        .toolbarTitleMenu {
            Picker("Meal type", selection: $mealType) {
                ForEach(MealType.allCases, id: \.self) { meal in
                    Text(meal.rawValue)
                        .tag(meal)
                }
            }
        }
        .toolbar {
            searchViewToolbar
        }
        .environment(\.editMode, $editModeState)
        .background {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
        }
        .onDisappear {
            withAnimation {
                searchViewModel.editingState = .inactive
                editModeState = .inactive
            }
            searchViewModel.selectedItems.removeAll()
        }
        .onChange(of: mealType) {
            searchViewModel.loadingBookmarks()
            
            Task {
                await searchViewModel
                    .loadBookmarksSearchView(for: mealType)
            }
            
            withAnimation {
                searchViewModel.editingState = .inactive
            }
            
            searchViewModel.selectedItems.removeAll()
            editModeState = .inactive
        }
    }
    
    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var searchViewToolbar: some ToolbarContent {
        switch searchViewModel.editingState {
        case .active:
            ToolbarItem(placement: .confirmationAction) {
                Button(role: .confirm) {
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
}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewSearchView.searchView
}
