//
//  SearchViewModel.swift
//  MealBytes
//
//  Created by Vlad Posherstnik on 04/03/2025.
//

import SwiftUI
import Combine

protocol SearchViewModelProtocol {
    func toggleBookmarkSearchView(for food: Food) async
    func loadBookmarksSearchView(for mealType: MealType) async
    func isBookmarkedSearchView(_ food: Food) -> Bool
    func resetQuery()
}

final class SearchViewModel: ObservableObject {
    @Published var foods: [Food] = []
    @Published var favoriteFoods: [Food] = []
    @Published var bookmarkedFoods: Set<Int> = []
    @Published var removalBookmarks: Set<Int> = []
    @Published var selectedItems = Set<Food.ID>()
    @Published var editingState: EditingState = .inactive
    @Published var appError: AppError?
    @Published var uniqueId: UUID?
    @Published var selectedMealType: MealType = .breakfast
    @Published var query: String = "" {
        didSet {
            if query.isEmpty {
                resetSearch()
            }
        }
    }
    @Published var showMealType: Bool = false
    @Published var isLoading: Bool = false
    @Published var isLoadingBookmarks: Bool = false
    @Published var showBottomBar: Bool = false
    @Published var showRemoveDialog: Bool = false
    
    private var maxResultsPerPage: Int = 20
    private var currentPage: Int = 0
    
    private let fatSecretManager: FatSecretManagerProtocol = FatSecretManager()
    private let firestore: FirebaseFirestoreProtocol = FirebaseFirestore()
    private let firebaseAuth: FirebaseAuthProtocol = FirebaseAuth()
    let mainViewModel: MainViewModelProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    init(mainViewModel: MainViewModelProtocol) {
        self.mainViewModel = mainViewModel
        setupBindingsSearchView()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    // MARK: - Search
    private func setupBindingsSearchView() {
        $query
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                guard let self else { return }
                self.currentPage = 0
                self.performSearch(query)
            }
            .store(in: &cancellables)
    }
    
    func performSearch(_ query: String) {
        if query.isEmpty {
            foods = favoriteFoods
            appError = nil
            isLoading = false
            return
        }
        
        isLoading = true
        
        Task {
            do {
                let foods = try await fatSecretManager.fetchFoods(
                    query: query,
                    page: currentPage
                )
                await MainActor.run {
                    self.foods = foods
                    self.appError = nil
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    switch error {
                    case let appError as AppError:
                        self.appError = appError
                    default: self.appError = .networkRefresh
                    }
                    self.isLoading = false
                }
            }
        }
    }
    
    private func resetSearch() {
        currentPage = 0
        foods = favoriteFoods
        appError = nil
        isLoading = false
    }
    
    // MARK: - Load Bookmarks Data
    func loadBookmarksSearchView(for mealType: MealType) async {
        guard firebaseAuth.currentUserExists() else { return }
        
        await MainActor.run {
            if query.isEmpty {
                isLoading = true
            }
            isLoadingBookmarks = true
            selectedMealType = mealType
        }
        
        do {
            let favorites = try await firestore.loadBookmarksFirestore(
                for: mealType
            )
            let bookmarked = Set(favorites.map { $0.searchFoodId })
            
            await MainActor.run {
                self.favoriteFoods = favorites
                self.bookmarkedFoods = bookmarked
                
                if query.isEmpty {
                    self.foods = favorites
                }
                
                self.isLoading = false
                self.isLoadingBookmarks = false
                self.appError = nil
            }
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.isLoadingBookmarks = false
            }
        }
    }
    
    func resetQuery() {
        query = ""
    }
    
    func mealSwitch(to meal: MealType) -> Bool {
        guard meal != selectedMealType else { return false }
        isLoading = true
        return true
    }
    
    // MARK: - Save Bookmarks
    func saveBookmarkOrder() async {
        await MainActor.run {
            if query.isEmpty {
                self.favoriteFoods = self.foods
            }
        }
        
        do {
            try await firestore.addBookmarkFirestore(
                favoriteFoods,
                for: selectedMealType
            )
        } catch {
            await MainActor.run {
                self.appError = .network
            }
        }
    }
    
    // MARK: - Remove Bookmarks
    func removeBookmarks(for ids: Set<Food.ID>) async {
        let updatedFavorites = favoriteFoods.filter {
            !ids.contains($0.searchFoodId)
        }
        let updatedBookmarkedFoods = bookmarkedFoods.subtracting(ids)
        
        await MainActor.run {
            withAnimation {
                self.favoriteFoods = updatedFavorites
                self.bookmarkedFoods = updatedBookmarkedFoods
                if query.isEmpty {
                    self.foods = updatedFavorites
                }
            }
        }
        
        do {
            try await firestore.addBookmarkFirestore(
                updatedFavorites,
                for: selectedMealType
            )
        } catch {
            await MainActor.run {
                self.appError = .network
            }
        }
    }
    
    // MARK: - Toggle Bookmark
    func toggleBookmarkSearchView(for food: Food) async {
        let isAdding = !bookmarkedFoods.contains(food.searchFoodId)
        
        let updatedBookmarkedFoods: Set<Int>
        if isAdding {
            updatedBookmarkedFoods = bookmarkedFoods
                .union([food.searchFoodId])
        } else {
            updatedBookmarkedFoods = bookmarkedFoods
                .subtracting([food.searchFoodId])
        }
        
        let updatedFavorites: [Food]
        if isAdding {
            if !favoriteFoods.contains(food) {
                updatedFavorites = favoriteFoods + [food]
            } else {
                updatedFavorites = favoriteFoods
            }
        } else {
            updatedFavorites = favoriteFoods.filter { $0 != food }
        }
        
        await MainActor.run {
            self.favoriteFoods = updatedFavorites
            self.bookmarkedFoods = updatedBookmarkedFoods
            if query.isEmpty {
                self.foods = updatedFavorites
            } else {
                self.foods = self.foods
            }
        }
        
        do {
            try await firestore.addBookmarkFirestore(
                updatedFavorites,
                for: selectedMealType
            )
        } catch {
            await MainActor.run {
                self.appError = .network
            }
        }
    }
    
    func bookmarkButtonRole(for food: Food) -> ButtonRole? {
        let isBookmarked = isBookmarkedSearchView(food)
        let isShowingBookmarks = query.isEmpty
        let isLastBookmark = favoriteFoods.count == 1
        return isBookmarked && isShowingBookmarks && !isLastBookmark
        ? .destructive
        : nil
    }
    
    // MARK: - Bookmark Management
    func isBookmarkedSearchView(_ food: Food) -> Bool {
        bookmarkedFoods.contains(food.searchFoodId)
        && !removalBookmarks.contains(food.searchFoodId)
    }
    
    // MARK: - Pagination
    enum PageDirection {
        case next
        case previous
    }
    
    func canLoadPage(direction: PageDirection) -> Bool {
        switch direction {
        case .next: foods.count == maxResultsPerPage
        case .previous: currentPage > 0
        }
    }
    
    func loadPage(direction: PageDirection) {
        isLoading = true
        switch direction {
        case .next: currentPage += 1
        case .previous:
            if currentPage > 0 {
                currentPage -= 1
            }
        }
        performSearch(query)
    }
    
    // MARK: - UI Helper
    var contentState: SearchContentState {
        if isLoading {
            .loading
        } else if let error = appError {
            .error(error)
        } else if foods.isEmpty {
            .empty
        } else {
            .results
        }
    }
    
    var bookmarkCountText: String {
        bookmarkedFoods.count == 1
        ? "1 bookmark"
        : "\(bookmarkedFoods.count) bookmarks"
    }
    
    var selectionStatusText: String {
        selectedItems.isEmpty
        ? "Select bookmarks"
        : selectedItems.count == 1
        ? "1 Bookmark Selected"
        : "\(selectedItems.count) Bookmarks Selected"
    }
    
    var removeDialogMessage: String {
        selectedItems.count == 1
        ? "The selected bookmark will be removed from favorites."
        : "The selected bookmarks will be removed from favorites."
    }
    
    var removeDialogTitle: String {
        let count = selectedItems.count
        return count == 1
        ? "Remove bookmark"
        : "Remove \(count) bookmarks"
    }
    
    var isEditing: Bool {
        editingState == .active
    }
}

enum EditingState {
    case inactive
    case active
}

enum SearchContentState: Equatable {
    case loading
    case error(AppError)
    case empty
    case results
}

extension SearchViewModel: SearchViewModelProtocol {}

#Preview {
    PreviewContentView.contentView
}

#Preview {
    PreviewSearchView.searchView
}
